*&---------------------------------------------------------------------*
*& Report ZSS13_KPI_DDL
*& SAP S/4HANA HANA Database Artifacts for SS13 KPI Telemetry
*& Bounty #353: Enterprise Modernization — SAP S/4HANA Integration
*&
*& This report contains CDS-compatible DDL definitions for the HANA
*& tables used to store Space Station 13 KPI telemetry data.
*& Execute once in SE38 or Eclipse ADT to create the persistence layer.
*&---------------------------------------------------------------------*
REPORT zss13_kpi_ddl.

* --- Table: ZSS13_ROUND ---
* One row per game round
SELECTION-SCREEN BEGIN OF BLOCK ddl WITH FRAME TITLE TEXT-001.
PARAMETERS: p_round RADIOBUTTON GROUP grp1 DEFAULT 'X',
            p_plyr  RADIOBUTTON GROUP grp1,
            p_mode  RADIOBUTTON GROUP grp1,
            p_antag RADIOBUTTON GROUP grp1,
            p_death RADIOBUTTON GROUP grp1,
            p_dmg   RADIOBUTTON GROUP grp1,
            p_all   RADIOBUTTON GROUP grp1.
SELECTION-SCREEN END OF BLOCK ddl.

START-OF-SELECTION.

  IF p_round = 'X' OR p_all = 'X'.
    PERFORM create_table_round.
  ENDIF.
  IF p_plyr = 'X' OR p_all = 'X'.
    PERFORM create_table_player_rounds.
  ENDIF.
  IF p_mode = 'X' OR p_all = 'X'.
    PERFORM create_table_mode_outcomes.
  ENDIF.
  IF p_antag = 'X' OR p_all = 'X'.
    PERFORM create_table_antag_outcomes.
  ENDIF.
  IF p_death = 'X' OR p_all = 'X'.
    PERFORM create_table_death_causes.
  ENDIF.
  IF p_dmg = 'X' OR p_all = 'X'.
    PERFORM create_table_station_damage.
  ENDIF.

  WRITE: / 'HANA tables for SS13 KPI telemetry created successfully.'.

*&---------------------------------------------------------------------*
*& Form CREATE_TABLE_ROUND
*&---------------------------------------------------------------------*
FORM create_table_round.
  DATA(lv_sql) = |CREATE COLUMN TABLE zss13_round ( | &&
    |  client         NVARCHAR(3)  DEFAULT '000' NOT NULL, | &&
    |  round_id        INTEGER               NOT NULL, | &&
    |  server_name     NVARCHAR(100),                    | &&
    |  server_address  NVARCHAR(45),                     | &&
    |  server_port     INTEGER,                          | &&
    |  start_time      TIMESTAMP,                        | &&
    |  end_time        TIMESTAMP,                        | &&
    |  end_reason      NVARCHAR(50),                     | &&
    |  duration_secs   DECIMAL(10,1),                    | &&
    |  player_count    INTEGER,                          | &&
    |  unique_characters INTEGER,                        | &&
    |  created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP, | &&
    |  PRIMARY KEY (client, round_id)                    | &&
    |)|.

  TRY.
      EXEC SQL.
        EXECUTE IMMEDIATE :lv_sql
      ENDEXEC.
      WRITE: / 'Table ZSS13_ROUND created.'.
    CATCH cx_sql_exception INTO DATA(lx_sql).
      WRITE: / 'ZSS13_ROUND already exists or error:', lx_sql->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_TABLE_PLAYER_ROUNDS
*&---------------------------------------------------------------------*
FORM create_table_player_rounds.
  DATA(lv_sql) = |CREATE COLUMN TABLE zss13_player_rounds ( | &&
    |  client       NVARCHAR(3) DEFAULT '000' NOT NULL, | &&
    |  round_id     INTEGER               NOT NULL, | &&
    |  player_ckey  NVARCHAR(50)          NOT NULL, | &&
    |  rounds_played INTEGER,                          | &&
    |  recorded_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP, | &&
    |  PRIMARY KEY (client, round_id, player_ckey)     | &&
    |)|.

  TRY.
      EXEC SQL.
        EXECUTE IMMEDIATE :lv_sql
      ENDEXEC.
      WRITE: / 'Table ZSS13_PLAYER_ROUNDS created.'.
    CATCH cx_sql_exception INTO DATA(lx_sql).
      WRITE: / 'ZSS13_PLAYER_ROUNDS already exists or error:', lx_sql->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_TABLE_MODE_OUTCOMES
*&---------------------------------------------------------------------*
FORM create_table_mode_outcomes.
  DATA(lv_sql) = |CREATE COLUMN TABLE zss13_mode_outcomes ( | &&
    |  client       NVARCHAR(3) DEFAULT '000' NOT NULL, | &&
    |  round_id     INTEGER               NOT NULL, | &&
    |  mode_name    NVARCHAR(50)          NOT NULL, | &&
    |  crew_wins    INTEGER DEFAULT 0,                  | &&
    |  crew_losses  INTEGER DEFAULT 0,                  | &&
    |  draws        INTEGER DEFAULT 0,                  | &&
    |  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP, | &&
    |  PRIMARY KEY (client, round_id, mode_name)        | &&
    |)|.

  TRY.
      EXEC SQL.
        EXECUTE IMMEDIATE :lv_sql
      ENDEXEC.
      WRITE: / 'Table ZSS13_MODE_OUTCOMES created.'.
    CATCH cx_sql_exception INTO DATA(lx_sql).
      WRITE: / 'ZSS13_MODE_OUTCOMES already exists or error:', lx_sql->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_TABLE_ANTAG_OUTCOMES
*&---------------------------------------------------------------------*
FORM create_table_antag_outcomes.
  DATA(lv_sql) = |CREATE COLUMN TABLE zss13_antag_outcomes ( | &&
    |  client       NVARCHAR(3) DEFAULT '000' NOT NULL, | &&
    |  round_id     INTEGER               NOT NULL, | &&
    |  antag_type   NVARCHAR(50)          NOT NULL, | &&
    |  antag_wins   INTEGER DEFAULT 0,                  | &&
    |  antag_losses INTEGER DEFAULT 0,                  | &&
    |  win_rate_pct DECIMAL(5,2),                       | &&
    |  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP, | &&
    |  PRIMARY KEY (client, round_id, antag_type)       | &&
    |)|.

  TRY.
      EXEC SQL.
        EXECUTE IMMEDIATE :lv_sql
      ENDEXEC.
      WRITE: / 'Table ZSS13_ANTAG_OUTCOMES created.'.
    CATCH cx_sql_exception INTO DATA(lx_sql).
      WRITE: / 'ZSS13_ANTAG_OUTCOMES already exists or error:', lx_sql->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_TABLE_DEATH_CAUSES
*&---------------------------------------------------------------------*
FORM create_table_death_causes.
  DATA(lv_sql) = |CREATE COLUMN TABLE zss13_death_causes ( | &&
    |  client         NVARCHAR(3) DEFAULT '000' NOT NULL, | &&
    |  round_id       INTEGER               NOT NULL, | &&
    |  death_cause    NVARCHAR(100)         NOT NULL, | &&
    |  death_count    INTEGER DEFAULT 0,                  | &&
    |  pct_of_total   DECIMAL(5,2),                       | &&
    |  updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP, | &&
    |  PRIMARY KEY (client, round_id, death_cause)        | &&
    |)|.

  TRY.
      EXEC SQL.
        EXECUTE IMMEDIATE :lv_sql
      ENDEXEC.
      WRITE: / 'Table ZSS13_DEATH_CAUSES created.'.
    CATCH cx_sql_exception INTO DATA(lx_sql).
      WRITE: / 'ZSS13_DEATH_CAUSES already exists or error:', lx_sql->get_text( ).
  ENDTRY.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_TABLE_STATION_DAMAGE
*&---------------------------------------------------------------------*
FORM create_table_station_damage.
  DATA(lv_sql) = |CREATE COLUMN TABLE zss13_station_damage ( | &&
    |  client         NVARCHAR(3) DEFAULT '000' NOT NULL, | &&
    |  round_id       INTEGER               NOT NULL, | &&
    |  damage_total   INTEGER DEFAULT 0,                  | &&
    |  damage_per_min DECIMAL(8,2),                       | &&
    |  updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP, | &&
    |  PRIMARY KEY (client, round_id)                     | &&
    |)|.

  TRY.
      EXEC SQL.
        EXECUTE IMMEDIATE :lv_sql
      ENDEXEC.
      WRITE: / 'Table ZSS13_STATION_DAMAGE created.'.
    CATCH cx_sql_exception INTO DATA(lx_sql).
      WRITE: / 'ZSS13_STATION_DAMAGE already exists or error:', lx_sql->get_text( ).
  ENDTRY.
ENDFORM.
