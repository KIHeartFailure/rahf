hfsos <- patreg %>%
  filter(DIA_all != "") %>%
  mutate(tmp_hfsos = stringr::str_detect(DIA_all, " I110| I130| I132| I255| I420| I423| I425| I426| I427| I428| I429| I43| I50| J81| K761| R57| 414W| 425E| 425F| 425G| 425H| 425W| 425X| 428")) %>%
  filter(tmp_hfsos)


hfdiag <-
  inner_join(rsdata315 %>%
    filter(casecontrol == "Case") %>%
    select(LopNr, shf_indexdtm),
  hfsos,
  by = "LopNr"
  )

hfdiag2 <- hfdiag %>%
  mutate(sosdtm = coalesce(
    UTDATUM,
    INDATUM
  )) %>%
  group_by(LopNr, shf_indexdtm) %>%
  arrange(sosdtm) %>%
  slice(1) %>%
  ungroup() %>%
  mutate(sos_durationhfforra = as.numeric(shf_indexdtm - sosdtm)) %>%
  select(LopNr, shf_indexdtm, sos_durationhfforra)

rsdata315 <- left_join(
  rsdata315, 
  hfdiag2, 
  by = c("LopNr", "shf_indexdtm")
)  