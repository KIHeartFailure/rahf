
# Additional variables from NPR -------------------------------------------

pdata <- create_sosvar(
  sosdata = patreg %>% filter(sos_source == "sv"),
  cohortdata = pdata,
  patid = LopNr,
  indexdate = shf_indexdtm,
  sosdate = INDATUM,
  diavar = HDIA,
  type = "out",
  name = "hospstrokemi",
  diakod = " I63| I21",
  censdate = censdtm,
  valsclass = "fac",
  meta_reg = "NPR (in)",
  warnings = FALSE
)
