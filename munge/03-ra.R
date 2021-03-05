
# Define RA ---------------------------------------------------------------

ra <- patreg %>%
  filter(
    sos_source == "ov",
    !is.na(INDATUM),
    INDATUM >= ymd("2001-01-01")
  ) %>%
  mutate(
    tmp_ra = stringr::str_detect(HDIA, " M05| M06"),
    tmpramvo = stringr::str_detect(MVO, "^(101|131)"),
    tmp_exra = stringr::str_detect(HDIA, " M073| L405| M45| M46| M32")
  ) %>%
  filter(tmp_ra | tmp_exra) %>%
  arrange(LopNr, INDATUM)

ramvo <- ra %>%
  filter(tmp_ra & tmpramvo) %>%
  group_by(LopNr) %>%
  arrange(INDATUM) %>%
  slice(1:2) %>%
  ungroup()

rautanmvo <- ra %>%
  filter(tmp_ra & !tmpramvo) %>%
  group_by(LopNr) %>%
  arrange(INDATUM) %>%
  slice(1) %>%
  ungroup()

ramvo3 <- bind_rows(ramvo, rautanmvo) %>%
  group_by(LopNr) %>%
  arrange(INDATUM) %>%
  slice(2) %>%
  ungroup()

raex <- ra %>%
  filter(tmp_exra) %>%
  group_by(LopNr) %>%
  arrange(INDATUM) %>%
  slice(1) %>%
  ungroup()

rafinal <- left_join(
  ramvo3 %>%
    select(LopNr, INDATUM),
  raex %>%
    select(LopNr, INDATUM),
  by = "LopNr"
) %>%
  filter(is.na(INDATUM.y) | INDATUM.x <= INDATUM.y) %>%
  rename(sos_radtm = INDATUM.x) %>%
  mutate(sos_ra = "Yes") %>%
  select(LopNr, sos_ra, sos_radtm)

pdata <- left_join(
  pdata,
  rafinal,
  by = "LopNr"
) %>%
  mutate(
    sos_com_ra_blank6mo = case_when(
      sos_ra == "Yes" & sos_radtm <= shf_indexdtm - 6 * 30 ~ "Yes",
      TRUE ~ "No"
    ),
    sos_com_ra = case_when(
      sos_ra == "Yes" & sos_radtm <= shf_indexdtm ~ "Yes",
      TRUE ~ "No"
    )
  )
