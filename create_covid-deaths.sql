-- Table: public.covid_deaths

-- DROP TABLE IF EXISTS public.covid_deaths;

CREATE TABLE IF NOT EXISTS public.covid_deaths
(
    iso_code character varying(55) COLLATE pg_catalog."default",
    continent character varying(55) COLLATE pg_catalog."default",
    location character varying(55) COLLATE pg_catalog."default",
    date date,
    population numeric,
    total_cases numeric,
    new_cases numeric,
    new_cases_smoothed numeric,
    total_deaths numeric,
    new_deaths numeric,
    new_deaths_smoothed double precision,
    total_cases_per_million double precision,
    new_cases_per_millionnew_cases_per_million double precision,
    new_cases_smoothed_per_million double precision,
    total_deaths_per_million double precision,
    new_deaths_per_million double precision,
    new_deaths_smoothed_per_million double precision,
    reproduction_rate double precision,
    icu_patients numeric,
    icu_patients_per_million double precision,
    hosp_patients numeric,
    hosp_patients_per_million double precision,
    weekly_icu_admissions numeric,
    weekly_icu_admissions_per_million double precision,
    weekly_hosp_admissions numeric,
    weekly_hosp_admissions_per_million double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.covid_deaths
    OWNER to postgres;