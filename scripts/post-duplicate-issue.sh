#!/bin/bash
# Posts a duplicate of issue #328 to test the external duplicate issue tracker

gh issue create \
  --title "[BOUNTY] [\$25] Open a duplicate of this issue to test our external duplicate issue tracker" \
  --body "Post an exact duplicate of this issue to this repository's issue tracker, without any additional front/back matter, links to the original issue, etc. If things go well, our self-hosted issue sorting system will correctly mark all of the duplicate issues as duplicates; we will clean up the test issues after. No other action is needed from you."
