# SS13 KPI — SAP S/4HANA Integration

Bounty #353: Enterprise Modernization Part 2 — Simple SAP Integration

## Architecture

```
SS13 Game Server                    SAP S/4HANA
┌─────────────────┐                ┌──────────────────┐
│  sap_kpi.dm     │   JSON export  │  ZSS13_KPI_INGEST │
│  (DM Subsystem) │──────────────▶ │  (ABAP Report)    │
│                 │                │         │         │
│  Extracts:      │   /data/sap_kpi│         ▼         │
│  - Rounds       │   /live_*.json │  HANA Column Store │
│  - Players      │   /round_*.json│         │         │
│  - Modes        │                │         ▼         │
│  - Antagonists  │                │  ZSS13_KPI_DISPLAY │
│  - Deaths       │                │  (ALV Dashboard)   │
│  - Damage       │                └──────────────────┘
└─────────────────┘
```

## Files

### DM (DreamMaker) - Game Server
- `code/controllers/subsystem/sap_kpi.dm` — KPI extraction subsystem
- Integration hooks in:
  - `code/controllers/subsystem/ticker.dm` — Round-end export
  - `code/modules/mob/login.dm` — Player login tracking
  - `code/modules/mob/living/death.dm` — Death cause tracking

### ABAP - SAP S/4HANA
- `zss13_kpi_ddl.abap` — HANA table definitions (6 tables)
- `zss13_kpi_ingest.abap` — JSON ingestion engine
- `zss13_kpi_display.abap` — KPI dashboard (7 views)

## KPIs Tracked

| Metric | Description |
|--------|-------------|
| Round Overview | Total rounds, players, duration, end reason |
| Player Engagement | Per-player round counts (top N) |
| Game Mode Performance | Win/loss/draw ratios per game mode |
| Antagonist Win Rates | Success rates per antagonist type |
| Death Cause Analytics | Top causes of death with percentages |
| Station Damage | Structural damage totals and severity |

### Bonus Creative Metrics (3+)
1. **Antagonist Win/Loss Ratios** — Per-antagonist-type success tracking
2. **Most Frequent Cause of Death** — Aggregated death analytics
3. **Total Station Structural Damage** — Per-round and per-minute damage trends

## Setup

### Game Server
1. Deploy `sap_kpi.dm` to `code/controllers/subsystem/`
2. Ensure `/data/sap_kpi/` directory exists (auto-created)
3. Restart server — subsystem auto-initializes

### SAP S/4HANA
1. Execute `ZSS13_KPI_DDL` in SE38 to create HANA tables
2. Schedule `ZSS13_KPI_INGEST` as a periodic batch job (SM37)
3. Use `ZSS13_KPI_DISPLAY` for interactive dashboard (SE38 or Fiori tile)

## SAP ABAP Standards Compliance

All ABAP code adheres to the Official SAP ABAP Reference and Keyword Documentation:
- Modern ABAP SQL with inline declarations (`DATA(var)`)
- `/UI2/CL_JSON` for JSON parsing (SAP Gateway standard)
- `CL_SALV_TABLE` for ALV output
- SAP HANA-optimized column-store table definitions
- Proper exception handling with `TRY/CATCH`
- ABAP Doc comments on all modules

## Bounty: $100 USD
**Pay on Merge** — per `Iamgoofball/-tg-station` Bounties and Issues Guidelines
