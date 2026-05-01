#!/bin/bash -ue
mkdir -p tests/cli/plots/
/usr/local/bin/analysiskmeans elbow -c counts_df.csv -cm cellmeta_df.csv -gm genemeta_df.csv -o tests/cli/plots/ -mn 5 -mx 10
