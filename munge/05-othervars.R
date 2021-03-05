pdata <- pdata %>%
  mutate(
    shf_ef_cat = factor(case_when(
      shf_ef == ">=50" ~ 3,
      shf_ef == "40-49" ~ 2,
      shf_ef %in% c("30-39", "<30") ~ 1
    ),
    labels = c("HFrEF", "HFmrEF", "HFpEF"),
    levels = 1:3
    ),
    shf_ef_cat2 = factor(case_when(
      shf_ef %in% c("40-49", ">=50") ~ 2,
      shf_ef %in% c("30-39", "<30") ~ 1
    ),
    labels = c("LVEF <40%", "LVEF =>40%"),
    levels = 1:2
    ),
    shf_device_cat = factor(case_when(
      is.na(shf_device) ~ NA_real_,
      shf_device %in% c("CRT", "CRT & ICD", "ICD") ~ 2,
      TRUE ~ 1
    ),
    labels = c("No", "CRT/ICD"),
    levels = 1:2
    ),

    shf_bmi_cat = case_when(
      is.na(shf_bmi) ~ NA_character_,
      shf_bmi < 30 ~ "<30",
      shf_bmi >= 30 ~ ">=30"
    ),

    # Outcomes
    sos_out_deathcvhosphfstrokemi = case_when(
      sos_out_deathcv == "Yes" |
        sos_out_hosphf == "Yes" |
        sos_out_hospstrokemi == "Yes" ~ "Yes",
      TRUE ~ "No"
    ),
    sos_outtime_deathcvhosphfstrokemi = pmin(sos_outtime_hospstrokemi, sos_outtime_hosphf),
    
    ## censor at 10 yrs
    sos_out_deathcvhosphfstrokemi = if_else(sos_outtime_deathcvhosphfstrokemi <= 365.25 * 10, as.character(sos_out_deathcvhosphfstrokemi), "No"),
    sos_outtime_deathcvhosphfstrokemi = pmin(sos_outtime_deathcvhosphfstrokemi, 365.25 * 10),
    
    sos_out_hosphf = if_else(sos_outtime_hosphf <= 365.25 * 10, as.character(sos_out_hosphf), "No"),
    sos_outtime_hosphf = pmin(sos_outtime_hosphf, 365.25 * 10),
    
    sos_out_death = if_else(sos_outtime_death <= 365.25 * 10, as.character(sos_out_death), "No"),
    sos_outtime_death = pmin(sos_outtime_death, 365.25 * 10)
  )
    

# income

inc <- pdata %>%
  group_by(shf_indexyear) %>%
  summarise(incmed = quantile(scb_dispincome,
    probs = 0.5,
    na.rm = TRUE
  ), .groups = "drop_last")

pdata <- left_join(
  pdata,
  inc,
  by = "shf_indexyear"
) %>%
  mutate(
    scb_dispincome_cat2 = case_when(
      scb_dispincome < incmed ~ 1,
      scb_dispincome >= incmed ~ 2
    ),
    scb_dispincome_cat2 = factor(scb_dispincome_cat2,
      levels = 1:2,
      labels = c("Below medium", "Above medium")
    )
  ) %>%
  select(-incmed)

pdata <- pdata %>%
  mutate(across(where(is_character), factor))
