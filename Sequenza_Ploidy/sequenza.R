#!/usr/bin/env Rscript
library(sequenza)

args = commandArgs(trailingOnly=TRUE)

# Sequenza
print(paste("Seqz:", " ", args[1]))
print(paste("Sample ID:", " ", args[2]))

seq_ext = sequenza.extract(args[1])
seq_fit = sequenza.fit(seq_ext)
sequenza.results(sequenza.extract = seq_ext, cp.table = seq_fit,  sample.id = args[2], out.dir = args[2])
# Done
