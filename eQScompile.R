# Compiling single-season and career numbers for my new metrics:
#   eQS: enhanced Quality Start
#   APPS: Average Pitching Performance Score
#   FInn: Free Innings
#   eQSrate: enhanced Quality Start conversion rate

source('~/WORKING_DIRECTORIES/quality.start/quality.R')
source('~/WORKING_DIRECTORIES/quality.start/addInn.R')

eQS25 <- quality(1925,"")
eQS26 <- quality(1926,"")
eQS27 <- quality(1927,"")
eQS28 <- quality(1928,"")
eQS29 <- quality(1929,"")
eQS30 <- quality(1930,"")
eQS31 <- quality(1931,"")
eQS32 <- quality(1932,"")
eQS33 <- quality(1933,"")
eQS34 <- quality(1934,"")
eQS35 <- quality(1935,"")
eQS36 <- quality(1936,"")
eQS37 <- quality(1937,"")
eQS38 <- quality(1938,"")
eQS39 <- quality(1939,"")
eQS40 <- quality(1940,"")
eQS41 <- quality(1941,"")
eQS42 <- quality(1942,"")
eQS43 <- quality(1943,"")
eQS44 <- quality(1944,"")
eQS45 <- quality(1945,"")
eQS46 <- quality(1946,"")
eQS47 <- quality(1947,"")
eQS48 <- quality(1948,"")
eQS49 <- quality(1949,"")
eQS50 <- quality(1950,"")
eQS51 <- quality(1951,"")
eQS52 <- quality(1952,"")
eQS53 <- quality(1953,"")
eQS54 <- quality(1954,"")
eQS55 <- quality(1955,"")
eQS56 <- quality(1956,"")
eQS57 <- quality(1957,"")
eQS58 <- quality(1958,"")
eQS59 <- quality(1959,"")
eQS60 <- quality(1960,"")
eQS61 <- quality(1961,"")
eQS62 <- quality(1962,"")
eQS63 <- quality(1963,"")
eQS64 <- quality(1964,"")
eQS65 <- quality(1965,"")
eQS66 <- quality(1966,"")
eQS67 <- quality(1967,"")
eQS68 <- quality(1968,"")
eQS69 <- quality(1969,"")
eQS70 <- quality(1970,"")
eQS71 <- quality(1971,"")
eQS72 <- quality(1972,"")
eQS73 <- quality(1973,"")
eQS74 <- quality(1974,"")
eQS75 <- quality(1975,"")
eQS76 <- quality(1976,"")
eQS77 <- quality(1977,"")
eQS78 <- quality(1978,"")
eQS79 <- quality(1979,"")
eQS80 <- quality(1980,"")
eQS81 <- quality(1981,"")
eQS82 <- quality(1982,"")
eQS83 <- quality(1983,"")
eQS84 <- quality(1984,"")
eQS85 <- quality(1985,"")
eQS86 <- quality(1986,"")
eQS87 <- quality(1987,"")
eQS88 <- quality(1988,"")
eQS89 <- quality(1989,"")
eQS90 <- quality(1990,"")
eQS91 <- quality(1991,"")
eQS92 <- quality(1992,"")
eQS00 <- quality(2000,"")
eQS93 <- quality(1993,"")
eQS94 <- quality(1994,"")
eQS95 <- quality(1995,"")
eQS96 <- quality(1996,"")
eQS97 <- quality(1997,"")
eQS98 <- quality(1998,"")
eQS99 <- quality(1999,"")
eQS01 <- quality(2001,"")
eQS02 <- quality(2002,"")
eQS03 <- quality(2003,"")
eQS04 <- quality(2004,"")
eQS05 <- quality(2005,"")
eQS06 <- quality(2006,"")
eQS07 <- quality(2007,"")
eQS08 <- quality(2008,"")
eQS09 <- quality(2009,"")
eQS10 <- quality(2010,"")
eQS11 <- quality(2011,"")
eQS12 <- quality(2012,"")
eQS13 <- quality(2013,"")
eQS14 <- quality(2014,"")
eQS15 <- quality(2015,"")
eQS16 <- quality(2016,"")
eQS17 <- quality(2017,"")
eQS18 <- quality(2018,"")

eQS_season <- bind_rows(eQS25,eQS26,eQS27,eQS28,eQS29,eQS30,
                        eQS31,eQS32,eQS33,eQS34,eQS35,eQS36,
                        eQS37,eQS38,eQS39,eQS40,eQS41,eQS42,
                        eQS43,eQS44,eQS45,eQS46,eQS47,eQS48,
                        eQS49,eQS50,eQS51,eQS52,eQS53,eQS54,
                        eQS55,eQS56,eQS57,eQS58,eQS59,eQS60,
                        eQS61,eQS62,eQS63,eQS64,eQS65,eQS66,
                        eQS67,eQS68,eQS69,eQS70,eQS71,eQS72,
                        eQS73,eQS74,eQS75,eQS76,eQS77,eQS78,
                        eQS79,eQS80,eQS81,eQS82,eQS83,eQS84,
                        eQS85,eQS86,eQS87,eQS88,eQS89,eQS90,
                        eQS91,eQS92,eQS93,eQS94,eQS95,eQS96,
                        eQS97,eQS98,eQS99,eQS00,eQS01,eQS02,
                        eQS03,eQS04,eQS05,eQS06,eQS07,eQS08,
                        eQS09,eQS10,eQS11,eQS12,eQS13,eQS14,
                        eQS15,eQS16,eQS17,eQS18)

eQS_career <- eQS_season %>% mutate(ones = 1)
eQS_career <- eQS_career %>% 
  group_by(PID) %>% 
  summarise(Seasons = sum(ones),
            First_Season = first(Year),
            Final_Season = last(Year),
            Career_Starts = sum(GS),
            eQS = sum(eQS),
            APPS = sum(APPS*GS)/sum(GS),
            FInn = addInn(FInn),
            eQSrate = sum(eQS)/sum(GS))

save.image("~/WORKING_DIRECTORIES/quality.start/eQS.RData")