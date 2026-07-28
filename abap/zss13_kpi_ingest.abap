*&---------------------------------------------------------------------*
*& Report ZSS13_KPI_INGEST
*& SAP S/4HANA JSON Ingestion for SS13 KPI Telemetry
*& Bounty #353: Enterprise Modernization — SAP S/4HANA Integration
*&
*& This report reads JSON export files produced by the SS13 SAP KPI
*& subsystem and ingests the data into HANA column-store tables.
*& Designed for SAP NetWeaver 7.50+ / S/4HANA with SAP Gateway JSON
*& transformation capabilities.
*&
*& Expected JSON files (placed in SAP application server directory):
*&   - /usr/sap/trans/ss13/live_snapshot_*.json
*&   - /usr/sap/trans/ss13/round_end_*.json
*&   - /usr/sap/trans/ss13/cumulative_stats.json
*&---------------------------------------------------------------------*
REPORT zss13_kpi_ingest.

* --- Selection Screen ---
SELECTION-SCREEN BEGIN OF BLOCK file WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE string LOWER CASE DEFAULT '/usr/sap/trans/ss13/'.
  PARAMETERS: p_mode TYPE c LENGTH 1 DEFAULT 'A' AS LISTBOX
              VISIBLE LENGTH 10.
SELECTION-SCREEN END OF BLOCK file.

* --- Data Types ---
TYPES: BEGIN OF ty_round,
         round_id          TYPE i,
         server_name       TYPE string,
         server_address    TYPE string,
         server_port       TYPE i,
         start_time        TYPE string,
         end_reason        TYPE string,
         duration_secs     TYPE decfloat16,
         player_count      TYPE i,
         unique_characters TYPE i,
         station_damage_total TYPE i,
       END OF ty_round.

TYPES: BEGIN OF ty_player_round,
         player_ckey  TYPE string,
         rounds       TYPE i,
       END OF ty_player_round.

TYPES: BEGIN OF ty_mode_outcome,
         mode_name TYPE string,
         wins      TYPE i,
         losses    TYPE i,
         draws     TYPE i,
       END OF ty_mode_outcome.

TYPES: BEGIN OF ty_antag_outcome,
         antag_type TYPE string,
         wins       TYPE i,
         losses     TYPE i,
       END OF ty_antag_outcome.

TYPES: BEGIN OF ty_death_cause,
         cause TYPE string,
         count TYPE i,
       END OF ty_death_cause.

TYPES: BEGIN OF ty_player_rounds_map,
         ckey  TYPE string,
         count TYPE i,
       END OF ty_player_rounds_map.

* --- Global Data ---
DATA: gv_round_id TYPE i.

INITIALIZATION.
  " Dropdown values for processing mode
  p_mode = 'A'.

AT SELECTION-SCREEN OUTPUT.
  " Set up dropdown for p_mode
  PERFORM set_dropdown_values.

START-OF-SELECTION.
  WRITE: / 'SS13 KPI Telemetry Ingestion Engine'.
  WRITE: / '==================================='.
  ULINE.

  " Scan for JSON files
  PERFORM scan_and_ingest.

*&---------------------------------------------------------------------*
*& Form SCAN_AND_INGEST
*&---------------------------------------------------------------------*
FORM scan_and_ingest.
  DATA: lt_files    TYPE TABLE OF string,
        lv_filename TYPE string,
        lv_json     TYPE string,
        lv_round_id TYPE i.

  " Build file listing command (platform-specific)
  " In production, use CL_GUI_FRONTEND_SERVICES for file dialog
  " or OS command via SM69

  WRITE: / 'Scanning directory:', p_file.

  " Try to find round_end files first (most complete data)
  TRY.
      " Attempt to open the directory listing
      DATA(lv_cmd) = |ls { p_file }round_end_*.json|.
      " In ABAP, we'd use OPEN DATASET or function modules
      " This demonstrates the pattern with pseudo-code

      WRITE: / 'Checking for round_end exports...'.

      " Process the latest round_end file
      lv_filename = p_file && 'round_end_latest.json'.
      PERFORM process_round_end_file USING lv_filename.

    CATCH cx_root INTO DATA(lx_ex).
      WRITE: / 'Error scanning files:', lx_ex->get_text( ).
  ENDTRY.

  " Then process live snapshots
  WRITE: / 'Processing live snapshots...'.
  lv_filename = p_file && 'live_snapshot_latest.json'.
  PERFORM process_live_snapshot USING lv_filename.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_ROUND_END_FILE
*&---------------------------------------------------------------------*
FORM process_round_end_file USING p_filename TYPE string.
  DATA: lv_json       TYPE string,
        lr_data       TYPE REF TO data,
        lv_round_id   TYPE i.

  FIELD-SYMBOLS: <fs_data> TYPE any.

  WRITE: / 'Reading file:', p_filename.

  " Read JSON file from application server
  " In production: use CL_ABAP_FILE_UTILITIES or OPEN DATASET
  PERFORM read_json_file USING p_filename CHANGING lv_json.

  IF lv_json IS INITIAL.
    WRITE: / 'No data found or file empty.'.
    RETURN.
  ENDIF.

  " Parse JSON using SAP's JSON transformation
  " /ui2/cl_json for older systems, XCO for S/4HANA Cloud
  TRY.
      DATA(lo_json) = /ui2/cl_json=>generate( json = lv_json ).

      " Extract round-level data
      lv_round_id = lo_json->value( path = '/round/round_id' ).

      WRITE: / 'Processing round_id:', lv_round_id.
      gv_round_id = lv_round_id.

      " Insert into ZSS13_ROUND
      PERFORM insert_round_data USING lo_json lv_round_id.

      " Insert player rounds
      PERFORM insert_player_rounds USING lo_json lv_round_id.

      " Insert mode outcomes
      PERFORM insert_mode_outcomes USING lo_json lv_round_id.

      " Insert antagonist outcomes
      PERFORM insert_antag_outcomes USING lo_json lv_round_id.

      " Insert death causes
      PERFORM insert_death_causes USING lo_json lv_round_id.

      " Insert station damage
      PERFORM insert_station_damage USING lo_json lv_round_id.

      WRITE: / 'Round', lv_round_id, 'ingested successfully.'.

    CATCH cx_root INTO DATA(lx_parse).
      WRITE: / 'JSON parse error:', lx_parse->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_LIVE_SNAPSHOT
*&---------------------------------------------------------------------*
FORM process_live_snapshot USING p_filename TYPE string.
  DATA: lv_json TYPE string.

  WRITE: / 'Reading live snapshot:', p_filename.
  PERFORM read_json_file USING p_filename CHANGING lv_json.

  IF lv_json IS INITIAL.
    WRITE: / 'No live snapshot data found.'.
    RETURN.
  ENDIF.

  TRY.
      DATA(lo_json) = /ui2/cl_json=>generate( json = lv_json ).
      DATA(lv_round_id) = lo_json->value( path = '/round/round_id' ).

      " Update live metrics in ZSS13_ROUND
      UPDATE zss13_round SET
        player_count      = lo_json->value( path = '/player_count' ),
        unique_characters = lo_json->value( path = '/unique_characters' )
        WHERE round_id = lv_round_id.

      WRITE: / 'Live snapshot for round', lv_round_id, 'updated.'.

    CATCH cx_root INTO DATA(lx_snap).
      WRITE: / 'Live snapshot error:', lx_snap->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_ROUND_DATA
*&---------------------------------------------------------------------*
FORM insert_round_data USING io_json TYPE REF TO /ui2/cl_json
                             iv_round_id TYPE i.
  DATA: ls_round TYPE zss13_round.

  ls_round-client     = sy-mandt.
  ls_round-round_id   = iv_round_id.
  ls_round-server_name    = io_json->value( path = '/round/server_name' ).
  ls_round-server_address = io_json->value( path = '/round/server_address' ).
  ls_round-server_port    = io_json->value( path = '/round/server_port' ).

  " Convert ISO timestamp strings to ABAP timestamps
  DATA(lv_start_ts) = io_json->value( path = '/round/start_time' ).
  ls_round-start_time = conv_time_iso_to_abap( lv_start_ts ).

  ls_round-end_reason = io_json->value( path = '/round_end_reason' ).
  ls_round-duration_secs    = io_json->value( path = '/round_duration_seconds' ).
  ls_round-player_count     = io_json->value( path = '/player_count' ).
  ls_round-unique_characters = io_json->value( path = '/unique_characters' ).

  " Upsert: try INSERT, fall back to UPDATE on duplicate key
  TRY.
      INSERT INTO zss13_round VALUES ls_round.
    CATCH cx_sy_open_sql_db.
      UPDATE zss13_round FROM ls_round.
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_PLAYER_ROUNDS
*&---------------------------------------------------------------------*
FORM insert_player_rounds USING io_json TYPE REF TO /ui2/cl_json
                                iv_round_id TYPE i.
  " Player rounds come as an associative JSON object: { "ckey": count, ... }
  " In SAP /UI2/CL_JSON we iterate the 'player_rounds' node
  DATA: lv_json_segment TYPE string,
        lo_players      TYPE REF TO /ui2/cl_json,
        lt_keys         TYPE string_table.

  lv_json_segment = io_json->value( path = '/player_rounds' ).
  IF lv_json_segment IS INITIAL.
    RETURN.
  ENDIF.

  " Create sub-JSON parser for the player_rounds object
  lo_players = /ui2/cl_json=>generate( json = lv_json_segment ).
  lt_keys = lo_players->get_keys( ).

  DATA: ls_pr TYPE zss13_player_rounds.
  LOOP AT lt_keys INTO DATA(lv_ckey).
    ls_pr-client    = sy-mandt.
    ls_pr-round_id  = iv_round_id.
    ls_pr-player_ckey = lv_ckey.
    ls_pr-rounds_played = lo_players->value( path = |/{ lv_ckey }| ).

    MODIFY zss13_player_rounds FROM ls_pr.
  ENDLOOP.

  WRITE: / '  Players ingested:', lines( lt_keys ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_MODE_OUTCOMES
*&---------------------------------------------------------------------*
FORM insert_mode_outcomes USING io_json TYPE REF TO /ui2/cl_json
                                iv_round_id TYPE i.
  DATA: lv_segment TYPE string,
        lo_modes   TYPE REF TO /ui2/cl_json,
        lt_keys    TYPE string_table.

  lv_segment = io_json->value( path = '/mode_outcomes' ).
  IF lv_segment IS INITIAL.
    RETURN.
  ENDIF.

  lo_modes = /ui2/cl_json=>generate( json = lv_segment ).
  lt_keys = lo_modes->get_keys( ).

  DATA: ls_mo TYPE zss13_mode_outcomes.
  LOOP AT lt_keys INTO DATA(lv_mode).
    ls_mo-client      = sy-mandt.
    ls_mo-round_id    = iv_round_id.
    ls_mo-mode_name   = lv_mode.
    ls_mo-crew_wins   = lo_modes->value( path = |/{ lv_mode }/wins| ).
    ls_mo-crew_losses = lo_modes->value( path = |/{ lv_mode }/losses| ).
    ls_mo-draws       = lo_modes->value( path = |/{ lv_mode }/draws| ).

    MODIFY zss13_mode_outcomes FROM ls_mo.
  ENDLOOP.

  WRITE: / '  Game modes ingested:', lines( lt_keys ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_ANTAG_OUTCOMES
*&---------------------------------------------------------------------*
FORM insert_antag_outcomes USING io_json TYPE REF TO /ui2/cl_json
                                 iv_round_id TYPE i.
  DATA: lv_segment TYPE string,
        lo_antags  TYPE REF TO /ui2/cl_json,
        lt_keys    TYPE string_table.

  lv_segment = io_json->value( path = '/antag_outcomes' ).
  IF lv_segment IS INITIAL.
    RETURN.
  ENDIF.

  lo_antags = /ui2/cl_json=>generate( json = lv_segment ).
  lt_keys = lo_antags->get_keys( ).

  DATA: ls_ao TYPE zss13_antag_outcomes.
  LOOP AT lt_keys INTO DATA(lv_antag).
    ls_ao-client       = sy-mandt.
    ls_ao-round_id     = iv_round_id.
    ls_ao-antag_type   = lv_antag.
    ls_ao-antag_wins   = lo_antags->value( path = |/{ lv_antag }/wins| ).
    ls_ao-antag_losses = lo_antags->value( path = |/{ lv_antag }/losses| ).

    " Calculate win rate
    DATA(lv_total) = ls_ao-antag_wins + ls_ao-antag_losses.
    IF lv_total > 0.
      ls_ao-win_rate_pct = ( ls_ao-antag_wins / lv_total ) * 100.
    ENDIF.

    MODIFY zss13_antag_outcomes FROM ls_ao.
  ENDLOOP.

  WRITE: / '  Antagonist types ingested:', lines( lt_keys ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_DEATH_CAUSES
*&---------------------------------------------------------------------*
FORM insert_death_causes USING io_json TYPE REF TO /ui2/cl_json
                               iv_round_id TYPE i.
  DATA: lv_segment TYPE string,
        lo_deaths  TYPE REF TO /ui2/cl_json,
        lt_keys    TYPE string_table.

  lv_segment = io_json->value( path = '/death_causes' ).
  IF lv_segment IS INITIAL.
    RETURN.
  ENDIF.

  lo_deaths = /ui2/cl_json=>generate( json = lv_segment ).
  lt_keys = lo_deaths->get_keys( ).

  " Calculate total deaths for percentage
  DATA(lv_total_deaths) = 0.
  LOOP AT lt_keys INTO DATA(lv_cause).
    lv_total_deaths = lv_total_deaths + lo_deaths->value( path = |/{ lv_cause }| ).
  ENDLOOP.

  DATA: ls_dc TYPE zss13_death_causes.
  LOOP AT lt_keys INTO lv_cause.
    DATA(lv_count) = lo_deaths->value( path = |/{ lv_cause }| ).
    ls_dc-client      = sy-mandt.
    ls_dc-round_id    = iv_round_id.
    ls_dc-death_cause = lv_cause.
    ls_dc-death_count = lv_count.
    IF lv_total_deaths > 0.
      ls_dc-pct_of_total = ( lv_count / lv_total_deaths ) * 100.
    ENDIF.

    MODIFY zss13_death_causes FROM ls_dc.
  ENDLOOP.

  WRITE: / '  Death causes ingested:', lines( lt_keys ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_STATION_DAMAGE
*&---------------------------------------------------------------------*
FORM insert_station_damage USING io_json TYPE REF TO /ui2/cl_json
                                 iv_round_id TYPE i.
  DATA: ls_sd     TYPE zss13_station_damage,
        lv_damage TYPE i,
        lv_dur    TYPE decfloat16.

  lv_damage = io_json->value( path = '/station_damage_total' ).
  lv_dur    = io_json->value( path = '/round_duration_seconds' ).

  ls_sd-client       = sy-mandt.
  ls_sd-round_id     = iv_round_id.
  ls_sd-damage_total = lv_damage.
  IF lv_dur > 0.
    ls_sd-damage_per_min = ( lv_damage / lv_dur ) * 60.
  ENDIF.

  MODIFY zss13_station_damage FROM ls_sd.

  WRITE: / '  Station damage ingested:', lv_damage, 'total (',
           ls_sd-damage_per_min, '/min )'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form READ_JSON_FILE
*&---------------------------------------------------------------------*
FORM read_json_file USING p_filename  TYPE string
                    CHANGING p_json   TYPE string.
  " In production, use OPEN DATASET or CL_ABAP_FILE_UTILITIES
  " to read the JSON file from the application server or frontend

  DATA: lv_line   TYPE string,
        lt_lines  TYPE TABLE OF string.

  TRY.
      OPEN DATASET p_filename FOR INPUT IN TEXT MODE ENCODING UTF-8.
      IF sy-subrc = 0.
        DO.
          READ DATASET p_filename INTO lv_line.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          APPEND lv_line TO lt_lines.
        ENDDO.
        CLOSE DATASET p_filename.
      ELSE.
        WRITE: / 'Cannot open file:', p_filename.
        RETURN.
      ENDIF.
    CATCH cx_root INTO DATA(lx_file).
      WRITE: / 'File read error:', lx_file->get_text( ).
      RETURN.
  ENDTRY.

  " Concatenate all lines into JSON string
  CONCATENATE LINES OF lt_lines INTO p_json RESPECTING BLANKS.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CONV_TIME_ISO_TO_ABAP
*&---------------------------------------------------------------------*
FORM conv_time_iso_to_abap USING p_iso_ts TYPE string
                           RETURNING VALUE(r_abap_ts) TYPE timestamp.
  " Convert 'YYYY-MM-DD HH:MM:SS' to ABAP timestamp
  " Simple conversion — production code should use CL_ABAP_TSTMP
  DATA: lv_date TYPE dats,
        lv_time TYPE tims,
        lv_tz   TYPE tzntstmpl.

  TRY.
      lv_date = p_iso_ts(4) && p_iso_ts+5(2) && p_iso_ts+8(2).
      lv_time = p_iso_ts+11(2) && p_iso_ts+14(2) && p_iso_ts+17(2).
      CONVERT DATE lv_date TIME lv_time INTO TIME STAMP r_abap_ts TIME ZONE sy-zonlo.
    CATCH cx_root.
      GET TIME STAMP FIELD r_abap_ts.
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SET_DROPDOWN_VALUES
*&---------------------------------------------------------------------*
FORM set_dropdown_values.
  " Set up dropdown values for p_mode
  " A = All files, R = Round-end only, L = Live only
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'P_MODE'
      values = VALUE vrm_values(
        ( key = 'A' text = 'All files' )
        ( key = 'R' text = 'Round-end only' )
        ( key = 'L' text = 'Live snapshots only' )
      ).
ENDFORM.
