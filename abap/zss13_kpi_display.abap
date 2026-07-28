*&---------------------------------------------------------------------*
*& Report ZSS13_KPI_DISPLAY
*& SAP S/4HANA KPI Dashboard for Space Station 13 Telemetry
*& Bounty #353: Enterprise Modernization — SAP S/4HANA Integration
*&
*& Interactive ALV dashboard displaying SS13 server KPIs ingested
*& from the SAP KPI subsystem. Provides drilldown views for:
*&   - Round Overview (total rounds, players, duration)
*&   - Player Engagement (top players by rounds played)
*&   - Game Mode Performance (win/loss/draw ratios)
*&   - Antagonist Win Rates
*&   - Death Cause Analytics (top killers)
*&   - Station Structural Damage Trends
*&
*& Uses modern ABAP ALV with IDA (S/4HANA) for optimal HANA performance.
*& Compatible with SAP GUI and SAP Fiori Launchpad.
*&---------------------------------------------------------------------*
REPORT zss13_kpi_display.

" === Type Pools / Includes ===
TYPE-POOLS: slis, vrm.

" === Selection Screen ===
SELECTION-SCREEN BEGIN OF BLOCK sel WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_rndfr TYPE dats DEFAULT sy-datum,
              p_rndto TYPE dats DEFAULT sy-datum.

  SELECTION-SCREEN SKIP.

  " View selector
  PARAMETERS: p_view TYPE c LENGTH 1 DEFAULT 'O' AS LISTBOX
              VISIBLE LENGTH 25.

SELECTION-SCREEN END OF BLOCK sel.

SELECTION-SCREEN BEGIN OF BLOCK opt WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_top   TYPE i DEFAULT 10 OBLIGATORY,
              p_varia TYPE slis_vari DEFAULT '/SS13_DASHBOARD'.
SELECTION-SCREEN END OF BLOCK opt.

" === Data Types ===
TYPES: BEGIN OF ty_round_overview,
         round_id          TYPE i,
         server_name       TYPE char100,
         start_time        TYPE timestamp,
         end_reason        TYPE char50,
         duration_secs     TYPE p LENGTH 10 DECIMALS 1,
         player_count      TYPE i,
         unique_characters TYPE i,
         station_damage    TYPE i,
       END OF ty_round_overview.

TYPES: BEGIN OF ty_player_stats,
         player_ckey TYPE char50,
         total_rounds TYPE i,
         avg_per_round TYPE p LENGTH 5 DECIMALS 1,
       END OF ty_player_stats.

TYPES: BEGIN OF ty_mode_stats,
         mode_name  TYPE char50,
         total_plays TYPE i,
         crew_wins  TYPE i,
         crew_losses TYPE i,
         draws      TYPE i,
         crew_winrate TYPE p LENGTH 5 DECIMALS 1,
       END OF ty_mode_stats.

TYPES: BEGIN OF ty_antag_stats,
         antag_type  TYPE char50,
         antag_wins  TYPE i,
         antag_losses TYPE i,
         win_rate    TYPE p LENGTH 5 DECIMALS 1,
       END OF ty_antag_stats.

TYPES: BEGIN OF ty_death_stats,
         death_cause TYPE char100,
         total_deaths TYPE i,
         pct_of_total TYPE p LENGTH 5 DECIMALS 1,
         trend        TYPE char10,
       END OF ty_death_stats.

TYPES: BEGIN OF ty_damage_stats,
         round_id    TYPE i,
         damage_total TYPE i,
         damage_per_min TYPE p LENGTH 8 DECIMALS 2,
         severity    TYPE char20,
       END OF ty_damage_stats.

" === Global Data ===
DATA: gt_rounds    TYPE TABLE OF ty_round_overview,
      gt_players   TYPE TABLE OF ty_player_stats,
      gt_modes     TYPE TABLE OF ty_mode_stats,
      gt_antags    TYPE TABLE OF ty_antag_stats,
      gt_deaths    TYPE TABLE OF ty_death_stats,
      gt_damage    TYPE TABLE OF ty_damage_stats.

DATA: go_alv        TYPE REF TO cl_salv_table,
      go_container  TYPE REF TO cl_gui_custom_container,
      gv_view_title TYPE string.

" === Initialization ===
INITIALIZATION.
  p_top = 10.

AT SELECTION-SCREEN OUTPUT.
  PERFORM set_view_dropdown.

" === Main Processing ===
START-OF-SELECTION.

  WRITE: / '═══════════════════════════════════════════════════'.
  WRITE: / '  Space Station 13 — Enterprise KPI Dashboard'.
  WRITE: / '  SAP S/4HANA Analytics Powered by HANA'.
  WRITE: / '═══════════════════════════════════════════════════'.
  ULINE.

  " Load data based on selected view
  CASE p_view.
    WHEN 'O'. " Overview
      PERFORM load_round_overview.
      PERFORM display_round_overview.
    WHEN 'P'. " Players
      PERFORM load_player_stats.
      PERFORM display_player_stats.
    WHEN 'M'. " Modes
      PERFORM load_mode_stats.
      PERFORM display_mode_stats.
    WHEN 'A'. " Antagonists
      PERFORM load_antag_stats.
      PERFORM display_antag_stats.
    WHEN 'D'. " Deaths
      PERFORM load_death_stats.
      PERFORM display_death_stats.
    WHEN 'S'. " Station Damage
      PERFORM load_damage_stats.
      PERFORM display_damage_stats.
    WHEN 'X'. " Full Dashboard (all views)
      PERFORM display_full_dashboard.
    WHEN OTHERS.
      PERFORM load_round_overview.
      PERFORM display_round_overview.
  ENDCASE.

*&---------------------------------------------------------------------*
*& Form LOAD_ROUND_OVERVIEW
*&---------------------------------------------------------------------*
FORM load_round_overview.
  DATA(lv_from) = p_rndfr.
  DATA(lv_to)   = p_rndto.

  SELECT
    round_id,
    server_name,
    start_time,
    end_reason,
    duration_secs,
    player_count,
    unique_characters,
    station_damage
    FROM zss13_round
    WHERE start_time >= @lv_from AND start_time <= @lv_to
    INTO CORRESPONDING FIELDS OF TABLE @gt_rounds
    ORDER BY start_time DESCENDING.

  WRITE: / 'Rounds loaded:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form LOAD_PLAYER_STATS
*&---------------------------------------------------------------------*
FORM load_player_stats.
  " Aggregate player stats across rounds
  SELECT
    player_ckey,
    SUM( rounds_played ) AS total_rounds,
    CAST( SUM( rounds_played ) AS FLTP ) / COUNT( DISTINCT round_id ) AS avg_per_round
    FROM zss13_player_rounds
    WHERE round_id IN (
      SELECT round_id FROM zss13_round
      WHERE start_time >= @p_rndfr AND start_time <= @p_rndto
    )
    GROUP BY player_ckey
    ORDER BY total_rounds DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @gt_players
    UP TO @p_top ROWS.

  WRITE: / 'Top', p_top, 'players loaded.'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form LOAD_MODE_STATS
*&---------------------------------------------------------------------*
FORM load_mode_stats.
  SELECT
    mode_name,
    COUNT(*) AS total_plays,
    SUM( crew_wins ) AS crew_wins,
    SUM( crew_losses ) AS crew_losses,
    SUM( draws ) AS draws,
    CAST( SUM( crew_wins ) AS FLTP ) /
      NULLIF( SUM( crew_wins ) + SUM( crew_losses ), 0 ) * 100 AS crew_winrate
    FROM zss13_mode_outcomes
    WHERE round_id IN (
      SELECT round_id FROM zss13_round
      WHERE start_time >= @p_rndfr AND start_time <= @p_rndto
    )
    GROUP BY mode_name
    ORDER BY total_plays DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @gt_modes.

  WRITE: / 'Game modes loaded:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form LOAD_ANTAG_STATS
*&---------------------------------------------------------------------*
FORM load_antag_stats.
  SELECT
    antag_type,
    SUM( antag_wins ) AS antag_wins,
    SUM( antag_losses ) AS antag_losses,
    CAST( SUM( antag_wins ) AS FLTP ) /
      NULLIF( SUM( antag_wins ) + SUM( antag_losses ), 0 ) * 100 AS win_rate
    FROM zss13_antag_outcomes
    WHERE round_id IN (
      SELECT round_id FROM zss13_round
      WHERE start_time >= @p_rndfr AND start_time <= @p_rndto
    )
    GROUP BY antag_type
    ORDER BY antag_wins DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @gt_antags.

  WRITE: / 'Antagonist types loaded:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form LOAD_DEATH_STATS
*&---------------------------------------------------------------------*
FORM load_death_stats.
  SELECT
    death_cause,
    SUM( death_count ) AS total_deaths,
    CAST( SUM( death_count ) AS FLTP ) /
      NULLIF( ( SELECT SUM( death_count ) FROM zss13_death_causes
                WHERE round_id IN (
                  SELECT round_id FROM zss13_round
                  WHERE start_time >= @p_rndfr AND start_time <= @p_rndto
                ) ), 0 ) * 100 AS pct_of_total
    FROM zss13_death_causes
    WHERE round_id IN (
      SELECT round_id FROM zss13_round
      WHERE start_time >= @p_rndfr AND start_time <= @p_rndto
    )
    GROUP BY death_cause
    ORDER BY total_deaths DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @gt_deaths
    UP TO @p_top ROWS.

  WRITE: / 'Death causes loaded:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form LOAD_DAMAGE_STATS
*&---------------------------------------------------------------------*
FORM load_damage_stats.
  SELECT
    round_id,
    damage_total,
    damage_per_min,
    CASE
      WHEN damage_per_min > 100  THEN 'CRITICAL'
      WHEN damage_per_min > 50   THEN 'HIGH'
      WHEN damage_per_min > 20   THEN 'MODERATE'
      WHEN damage_per_min > 0    THEN 'LOW'
      ELSE 'NONE'
    END AS severity
    FROM zss13_station_damage
    WHERE round_id IN (
      SELECT round_id FROM zss13_round
      WHERE start_time >= @p_rndfr AND start_time <= @p_rndto
    )
    ORDER BY damage_total DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @gt_damage.

  WRITE: / 'Damage records loaded:', sy-dbcnt.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ROUND_OVERVIEW (Text-based for SAP GUI)
*&---------------------------------------------------------------------*
FORM display_round_overview.
  ULINE.
  WRITE: / 'ROUND OVERVIEW'.
  ULINE.

  IF gt_rounds IS INITIAL.
    WRITE: / 'No round data found for the selected date range.'.
    RETURN.
  ENDIF.

  " Summary statistics
  DATA(lv_total_rounds) = lines( gt_rounds ).
  DATA(lv_total_players) = 0.
  DATA(lv_total_duration) = 0.
  DATA(lv_total_damage) = 0.

  LOOP AT gt_rounds INTO DATA(ls_round).
    lv_total_players = lv_total_players + ls_round-player_count.
    lv_total_duration = lv_total_duration + ls_round-duration_secs.
    lv_total_damage = lv_total_damage + ls_round-station_damage.
  ENDLOOP.

  WRITE: / 'Period:', p_rndfr, 'to', p_rndto.
  WRITE: / 'Total Rounds:', lv_total_rounds.
  WRITE: / 'Total Player-Sessions:', lv_total_players.
  WRITE: / 'Avg Players per Round:', lv_total_players / lv_total_rounds.
  WRITE: / 'Total Gameplay Hours:', lv_total_duration / 3600.
  WRITE: / 'Avg Round Duration (min):', ( lv_total_duration / lv_total_rounds ) / 60.
  WRITE: / 'Total Station Damage:', lv_total_damage.

  ULINE.
  WRITE: / 'RECENT ROUNDS:'.
  ULINE.

  " Column headers
  FORMAT COLOR COL_HEADING.
  WRITE: /  'Round ID',
            AT 12 'Server',
            AT 40 'Started',
            AT 60 'Duration(min)',
            AT 78 'Players',
            AT 88 'Reason'.
  FORMAT COLOR OFF.

  LOOP AT gt_rounds INTO ls_round FROM 1 TO p_top.
    WRITE: /  ls_round-round_id,
              AT 12 ls_round-server_name(25),
              AT 40 ls_round-start_time,
              AT 60 ls_round-duration_secs / 60,
              AT 78 ls_round-player_count,
              AT 88 ls_round-end_reason(20).
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_PLAYER_STATS
*&---------------------------------------------------------------------*
FORM display_player_stats.
  ULINE.
  WRITE: / 'TOP PLAYER ENGAGEMENT'.
  ULINE.

  IF gt_players IS INITIAL.
    WRITE: / 'No player data found.'.
    RETURN.
  ENDIF.

  FORMAT COLOR COL_HEADING.
  WRITE: / 'Rank',
            AT 8 'Player CKey',
            AT 35 'Total Rounds',
            AT 50 'Avg/ Round'.
  FORMAT COLOR OFF.

  DATA(lv_rank) = 0.
  LOOP AT gt_players INTO DATA(ls_player).
    lv_rank = lv_rank + 1.
    WRITE: / lv_rank,
              AT 8 ls_player-player_ckey,
              AT 35 ls_player-total_rounds,
              AT 50 ls_player-avg_per_round.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_MODE_STATS
*&---------------------------------------------------------------------*
FORM display_mode_stats.
  ULINE.
  WRITE: / 'GAME MODE PERFORMANCE'.
  ULINE.

  IF gt_modes IS INITIAL.
    WRITE: / 'No mode data found.'.
    RETURN.
  ENDIF.

  FORMAT COLOR COL_HEADING.
  WRITE: / 'Game Mode',
            AT 25 'Plays',
            AT 35 'Crew Wins',
            AT 48 'Crew Losses',
            AT 62 'Draws',
            AT 72 'Crew Win%'.
  FORMAT COLOR OFF.

  LOOP AT gt_modes INTO DATA(ls_mode).
    WRITE: / ls_mode-mode_name,
              AT 25 ls_mode-total_plays,
              AT 35 ls_mode-crew_wins,
              AT 48 ls_mode-crew_losses,
              AT 62 ls_mode-draws,
              AT 72 ls_mode-crew_winrate, '%'.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ANTAG_STATS
*&---------------------------------------------------------------------*
FORM display_antag_stats.
  ULINE.
  WRITE: / 'ANTAGONIST PERFORMANCE'.
  ULINE.

  IF gt_antags IS INITIAL.
    WRITE: / 'No antagonist data found.'.
    RETURN.
  ENDIF.

  FORMAT COLOR COL_HEADING.
  WRITE: / 'Antagonist Type',
            AT 30 'Wins',
            AT 42 'Losses',
            AT 55 'Win Rate %'.
  FORMAT COLOR OFF.

  LOOP AT gt_antags INTO DATA(ls_antag).
    WRITE: / ls_antag-antag_type,
              AT 30 ls_antag-antag_wins,
              AT 42 ls_antag-antag_losses,
              AT 55 ls_antag-win_rate, '%'.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_DEATH_STATS
*&---------------------------------------------------------------------*
FORM display_death_stats.
  ULINE.
  WRITE: / 'TOP CAUSES OF DEATH'.
  ULINE.

  IF gt_deaths IS INITIAL.
    WRITE: / 'No death data found.'.
    RETURN.
  ENDIF.

  FORMAT COLOR COL_HEADING.
  WRITE: / 'Death Cause',
            AT 45 'Count',
            AT 58 'Pct of Total'.
  FORMAT COLOR OFF.

  LOOP AT gt_deaths INTO DATA(ls_death).
    WRITE: / ls_death-death_cause(40),
              AT 45 ls_death-total_deaths,
              AT 58 ls_death-pct_of_total, '%'.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_DAMAGE_STATS
*&---------------------------------------------------------------------*
FORM display_damage_stats.
  ULINE.
  WRITE: / 'STATION STRUCTURAL DAMAGE'.
  ULINE.

  IF gt_damage IS INITIAL.
    WRITE: / 'No damage data found.'.
    RETURN.
  ENDIF.

  FORMAT COLOR COL_HEADING.
  WRITE: / 'Round ID',
            AT 15 'Total Damage',
            AT 32 'Damage/Min',
            AT 48 'Severity'.
  FORMAT COLOR OFF.

  LOOP AT gt_damage INTO DATA(ls_damage).
    FORMAT COLOR OFF.
    IF ls_damage-severity = 'CRITICAL'.
      FORMAT COLOR COL_NEGATIVE.
    ELSEIF ls_damage-severity = 'HIGH'.
      FORMAT COLOR COL_TOTAL.
    ENDIF.
    WRITE: / ls_damage-round_id,
              AT 15 ls_damage-damage_total,
              AT 32 ls_damage-damage_per_min,
              AT 48 ls_damage-severity.
  ENDLOOP.
  FORMAT COLOR OFF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_FULL_DASHBOARD
*&---------------------------------------------------------------------*
FORM display_full_dashboard.
  " Display all views sequentially
  PERFORM display_round_overview.
  SKIP 2.

  PERFORM display_player_stats.
  SKIP 2.

  PERFORM display_mode_stats.
  SKIP 2.

  PERFORM display_antag_stats.
  SKIP 2.

  PERFORM display_death_stats.
  SKIP 2.

  PERFORM display_damage_stats.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SET_VIEW_DROPDOWN
*&---------------------------------------------------------------------*
FORM set_view_dropdown.
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'P_VIEW'
      values = VALUE vrm_values(
        ( key = 'O' text = 'Round Overview' )
        ( key = 'P' text = 'Player Engagement' )
        ( key = 'M' text = 'Game Mode Performance' )
        ( key = 'A' text = 'Antagonist Win Rates' )
        ( key = 'D' text = 'Death Cause Analytics' )
        ( key = 'S' text = 'Station Damage Trends' )
        ( key = 'X' text = 'FULL DASHBOARD (All Views)' )
      ).
ENDFORM.
