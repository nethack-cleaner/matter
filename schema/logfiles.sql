-- === logfiles table ===
--
-- logfiles_i
-- Integer used to reference the logfiles entry; note that it is
-- also referenced from nhdb configuration (nhdb-def.json)! Don't
-- change this, preferably. Also, for /dev/null games, this id
-- MUST be the year of the tournament. See function process_streaks()
-- in nhdb-stats.pl.
--
-- descr
-- Description of the entry; only shown on the About page
--
-- server
-- Three letter server acronym in lowercase (such as "nao" for
-- nethack.alt.org, "ade" for acehack.de etc.).
--
-- variant
-- Variant acronym in lowercase (such as "nh" for vanilla NetHack,
-- "ace" for AceHack, "nh4" for NetHack4 etc.)
--
-- version
-- This is used as an additional distinguisher that can be acted upon
-- (primarily by the feeder to modify its parsing behaviour).
--
-- logurl
-- Fully qualified URL of xlogfile.
--
-- localfile
-- Filename of a logfile on local filesystem.
--
-- dumpurl
-- Determines location of the game dumps
--
-- rcfileurl
-- Determines location of player rc files
-- 
-- oper
-- If true, the feeder will process this entry; if false the logfile
-- will not be processed, essentially it won't exist for the feeder.
-- This has no effect on games alread in the database and stats
-- generator will still load all logfiles and process all games in db.
-- Note, that if a full db reload is needed, oper must be set to true
-- for the logfile to be reloaded! 
--
-- static
-- If true, the feeder will not try to download the file from logurl,
-- even if it is defined. This allows static logfiles to be part of the
-- dataset (such as devnull logfiles, logfiles from discontinued sites etc.)
-- In general, if you want to use static file, you probably also want 
-- to set 'oper' to false.
--
-- httpcon
-- Site supports HTTP continuation, allowing incremental downloads.
-- If false, the whole file needs to be redownloaded every time.
--
-- tz
-- Time zone used for this logfile
--
-- fpos
-- Last file position; this is the file position the feeder will
-- read the file from on the next run. After the feeder has run and
-- processed the logfile, it is set to the log's filesize. By resetting
-- this field, one forces the whole logfile to be parsed and fed into
-- db again (but that won't erase the redundant db entries!)
--
-- lastchk
-- Time of last processing of the logfile.


DROP TABLE IF EXISTS logfiles;

CREATE TABLE logfiles (
  logfiles_i  int,
  descr       varchar(64),
  server      varchar(3) NOT NULL,
  variant     varchar(3) NOT NULL,
  version     varchar(16),
  logurl      varchar(128),
  localfile   varchar(128) NOT NULL,
  dumpurl     varchar(128),
  rcfileurl   varchar(128),
  oper        boolean,
  static      boolean,
  httpcont    boolean,
  tz          varchar(32),
  fpos        bigint,
  lastchk     timestamp with time zone,
  PRIMARY KEY (logfiles_i)
);

GRANT SELECT, UPDATE ON logfiles TO nhdbfeeder;
GRANT SELECT ON logfiles TO nhdbstats;


-----------------------------------------------------------------------------
-- nethack.alt org/NAO ------------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  1, 'nethack.alt.org (3.4.3)', 
  'nao', 'nh', '3.4.3',
  'http://alt.org/nethack/xlogfile.full.txt',
  'nao.nh.343.log',
  'http://alt.org/nethack/userdata/%U/%u/dumplog/%s.nh343.txt',
  'http://alt.org/nethack/userdata/%u/%u.nh343rc',
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  20, 'nethack.alt.org (3.6.0)',
  'nao', 'nh', '3.6.0',
  'https://alt.org/nethack/xlogfile.nh360',
  'nao.nh.360.log',
  NULL,
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  21, 'nethack.alt.org (3.6.1dev)',
  'nao', 'nh', '3.6.1',
  'https://alt.org/nethack/xlogfile.nh361dev',
  'nao.nh.361dev.log',
  NULL,
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- acehack.de/ADE (defunct) -------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  5, 'acehack.de',
  'ade', 'ace', NULL,
  'https://ascension.run/history/ade/xlogfiles/acehack',
  'ade.ace.log', 
  'https://ascension.run/history/ade/userdata/%u/acehack/dumplog/%s',
  NULL,
  TRUE, TRUE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- eu.un.nethack.nu/UNE -----------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  3, 'eu.un.nethack.nu', 
  'une', 'unh', '5',
  'http://un.nethack.nu/logs/xlogfile-eu',
  'une.unh.log',
  'http://un.nethack.nu/user/%u/dumps/eu/%u.%e.txt.html',
  'http://un.nethack.nu/rcfiles/%u.nethackrc',
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- us.un.nethack.nu/UNU -----------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  10, 'us.un.nethack.nu',
  'unu', 'unh', '5',
  'http://un.nethack.nu/logs/xlogfile-us',
  'unu.unh.log',
  'http://un.nethack.nu/user/%u/dumps/us/%u.%e.txt.html',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- nethack4.org/N4O ---------------------------------------------------------
-----------------------------------------------------------------------------
-- dumplogs work in a non-standard way, so 'dumpurl' field here is only
-- base URL, not URL template

INSERT INTO logfiles VALUES (
  4, 'nethack4.org (4.3)', 
  'n4o', 'nh4', '4.3',
  'http://nethack4.org/xlogfile.txt',
  'n4o.nh4-3.log',
  'http://nethack4.org/dumps/',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  8, 'nethack4.org (4.2)',
  'n4o', 'nh4', '4.2',
  'http://nethack4.org/4.2-xlogfile',
  'n4o.nh4-2.log',
  NULL,
  NULL,
  TRUE, TRUE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- sporkhack.com/SHC (defunct) ----------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  6, 'sporkhack.com',
  'shc', 'sh', NULL,
  'http://sporkhack.com/xlogfile',
  'shc.sh.log',
  NULL,
  NULL,
  TRUE, TRUE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- grunthack.org/GHO --------------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  7, 'grunthack.org',
  'gho', 'gh', NULL,
  'http://grunthack.org/xlogfile',
  'gho.gh.log', 
  'http://grunthack.org/userdata/%U/%u/dumplog/%s.gh020.txt',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- dnethack.ilbelkyr.de/DID (defunct) ---------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  9, 'dnethack.ilbelkyr.de', 
  'did', 'dnh', NULL,
  'http://dnethack.ilbelkyr.de/xlogfile.txt',
  'did.dnh.log',
  NULL,
  'https://ascension.run/history/ilbelkyr/userdata/%u/dnethack/dumplog/%s',
  TRUE, TRUE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- acehack.eu/AEU (defunct) -------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
 11, 'acehack.eu',
 'aeu', 'ace', NULL,
 'https://ascension.run/history/aeu/xlogfiles/acehack',
 'aeu.ace.log',
 'https://ascension.run/history/aeu/userdata/%u/acehack/dumplog/%s',
 NULL,
 TRUE, TRUE, FALSE,
 'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
--- ascension.run -----------------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  2, 'ascension.run (NetHack)',
  'asc', 'nh', '3.4.3',
  'https://ascension.run/xlogfiles/nethack',
  'asc.nh.log',
  'https://ascension.run/userdata/%u/nethack/dumplog/%s',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  12, 'ascension.run (dNetHack)',
  'asc', 'dnh', NULL,
  'https://ascension.run/xlogfiles/dnethack',
  'asc.dnh.log',
  'https://ascension.run/userdata/%u/dnethack/dumplog/%s',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  13, 'ascension.run (Fourk)',
  'asc', 'nhf', NULL,
  'https://ascension.run/xlogfiles/nhfourk',
  'asc.nhf.log',
  'https://ascension.run/userdata/%u/nhfourk/dumplog/',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  14, 'ascension.run (SporkHack 2015)',
  'asc', 'sh', NULL,
  'https://ascension.run/history/junethack2015/xlogfiles/sporkhack',
  'asc.sh.2015.log',
  'https://ascension.run/history/junethack2015/userdata/%u/sporkhack/dumplog/%s',
  NULL,
  TRUE, TRUE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  15, 'ascension.run (GruntHack 2015)',
  'asc', 'gh', NULL,
  'https://ascension.run/history/junethack2015/xlogfiles/grunthack',
  'asc.gh.2015.log',
  'https://ascension.run/history/junethack2015/userdata/%u/grunthack/dumplog/%s',
  NULL,
  TRUE, TRUE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  16, 'ascension.run (UnNetHack)',
  'asc', 'unh', NULL,
  'https://ascension.run/xlogfiles/unnethack',
  'asc.unh.log',
  'https://ascension.run/userdata/%u/unnethack/dumplog/%s',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  17, 'ascension.run (DynaHack)',
  'asc', 'dyn', NULL,
  'https://ascension.run/xlogfiles/dynahack',
  'asc.dyn.log',
  'https://ascension.run/userdata/%u/dynahack/dumplog/',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  18, 'ascension.run (NetHack4)',
  'asc', 'nh4', '4.3',
  'https://ascension.run/xlogfiles/nethack4',
  'asc.nh4.log',
  'https://ascension.run/userdata/%u/nethack4/dumplog/',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  19, 'ascension.run (FiqHack)',
  'asc', 'fh', NULL,
  'https://ascension.run/xlogfiles/fiqhack',
  'asc.fh.log',
  'https://ascension.run/userdata/%u/fiqhack/dumplog/',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
--- hardfought.org ----------------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  22, 'hardfought.org (NetHack 3.4.3)',
  'hdf', 'nh', NULL,
  'http://www.hardfought.org/xlogfiles/nh343/xlogfile',
  'hdf.nh.343.log',
  'http://www.hardfought.org/userdata/%U/%u/nh343/dumplog/%s.nh343.txt',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  23, 'hardfought.org (GruntHack)',
  'hdf', 'gh', NULL,
  'http://www.hardfought.org/xlogfiles/gh020/xlogfile',
  'hdf.gh.log',
  'http://www.hardfought.org/userdata/%U/%u/gh020/dumplog/%s.gh020.txt',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  24, 'hardfought.org (UnNetHack)',
  'hdf', 'unh', NULL,
  'http://www.hardfought.org/xlogfiles/un531/xlogfile',
  'hdf.unh.log',
  'http://www.hardfought.org/userdata/%U/%u/un531/dumplog/%s.un531.txt.html',
  NULL,
  TRUE, FALSE, TRUE,
  'UTC', NULL, NULL
);

-----------------------------------------------------------------------------
-- nethack.devnull.com/DEV --------------------------------------------------
-----------------------------------------------------------------------------

INSERT INTO logfiles VALUES (
  2006, '/dev/null 2006',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2006.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2007, '/dev/null 2007',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2007.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2008, '/dev/null 2008',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2008.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2009, '/dev/null 2009',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2009.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2010, '/dev/null 2010',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2010.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2011, '/dev/null 2011',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2011.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2012, '/dev/null 2012',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2012.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2013, '/dev/null 2013',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2013.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2014, '/dev/null 2014',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2014.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2015, '/dev/null 2015',
  'dev', 'nh', NULL,
  NULL,
  'devnull-2015.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);

INSERT INTO logfiles VALUES (
  2016, '/dev/null 2016',
  'dev', 'nh', NULL,
  'http://nethack.devnull.net/tournament/scores.xlogfile',
  'devnull-2016.log',
  NULL,
  NULL,
  TRUE, TRUE, FALSE,
  'UTC', NULL, NULL
);
