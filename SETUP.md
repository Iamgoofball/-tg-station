# BYOND Setup for Unit Tests (flaky-tests-281)

## Exact Requirements
- **BYOND Version**: 516.1659 (see .tgs.yml and dependencies.sh)
- **Platform**: Linux preferred for headless CI-like runs (macOS supported but DreamDaemon may require additional setup for -close mode).
- **Installation**:
  1. Download from https://www.byond.com/download/build/516/516.1659_byond_linux.zip (or mac equivalent).
  2. Extract to ~/BYOND/
  3. Run `make here` in byond/ dir.
  4. Add `~/BYOND/byond/bin` to PATH.
  5. Source `~/BYOND/byond/bin/byondsetup`
- **Compile Command**: DreamMaker -DUNIT_TESTS tgstation.dme (or via tools/deploy.sh ci_test)
- **Run Command**: DreamDaemon tgstation.dmb -close -trusted -verbose -params "log-directory=ci" (uses ci_test/config with UNIT_TESTS implicitly via map or defines)
- **Test Map**: Uses _maps/templates/unit_tests.dmm or runtimestation for CI.
- **Output**: data/unit_tests.json contains results. clean_run.lk for success.
- **Looping**: Use a wrapper script to repeat compile+run, parse JSON for failures, log to flaky.log.
- **Dependencies**: rust-g, dreamluau, MySQL for full CI, but unit tests can run with minimal.

## Notes
- macOS arm64: Use native BYOND installer or cross-compile setup may be needed. Test in Linux VM/Docker for reliability.
- For 50 clean runs: Script should track streak, stop on failure, fix identified failing tests (often in create_and_destroy due to qdel, GC, Initialize issues).
- Root causes typically: missing Destroy() calls, global state leakage, timing/race conditions in SS, random() without seed, improper test isolation.

Update this as setup is completed.
Submitted as part of fix for #281.
