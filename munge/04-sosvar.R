
# Additional variables from NPR -------------------------------------------

pdata <- pdata %>%
  mutate(censdtm = shf_indexdtm + sos_outtime_death)

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
  valsclass = "num",
  meta_reg = "NPR (in)",
  warnings = FALSE
)


pdata <- pdata %>%
  mutate(sos_out_hospstrokemi = factor(sos_out_hospstrokemi,
    levels = c(0, 1),
    labels = c("No", "Yes")
  ))
