

# Inclusion/exclusion criteria --------------------------------------------------------

pdata <- rsdata322 %>%
  filter(casecontrol == "Case")

flow <- c("Number of posts (cases) in SHFDB3", nrow(pdata))

pdata <- pdata %>%
  group_by(LopNr) %>%
  arrange(shf_indexdtm) %>%
  slice(1) %>%
  ungroup()

flow <- rbind(flow, c("First post/patient", nrow(pdata)))

pdata <- pdata %>%
  filter(sos_durationhf <= 14 | is.na(sos_durationhf))
flow <- rbind(flow, c("No history (from 1987, in- or out-patient, all positions) of HF in NPR*", nrow(pdata)))

pdata <- pdata %>%
  filter(shf_durationhf == "<6mo")
flow <- rbind(flow, c("Duration of HF < 6 mo in SwedeHF", nrow(pdata)))

pdata <- pdata %>%
  filter(shf_indexdtm >= ymd("2003-01-01"))
flow <- rbind(flow, c("Indexdate >= 1 Jan 2003 (start NPR out-pat 2001 + 2 years)", nrow(pdata)))

pdata <- pdata %>%
  filter(!is.na(shf_ef))
flow <- rbind(flow, c("No missing EF", nrow(pdata)))

flow <- rbind(flow, c(".  whereof out-patients", nrow(pdata %>% filter(shf_location == "Out-patient"))))
flow <- rbind(flow, c(".  whereof in-patients", nrow(pdata %>% filter(shf_location == "In-patient"))))

colnames(flow) <- c("Criteria", "N")
