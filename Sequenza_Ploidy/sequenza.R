#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# Sequenza
seq_ext = sequenze.extract(args[1])
seq_fit = sequenze.fit(seq_ext)
sequenza.results(sequenza.extract = seq_ext, cp.table = seq_fit,  sample.id = args[2], out.dir = args[2])
# Done
