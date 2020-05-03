FUNCTION fix_l1b2, $
   misr_ptr, $
   radrd_ptr, $
   rad_ptr, $
   brf_ptr, $
   rdqi_ptr, $
   scalf_ptr, $
   convf_ptr, $
   fixed_misr_ptr, $
   fixed_radrd_ptr, $
   fixed_rad_ptr, $
   fixed_brf_ptr, $
   fixed_rdqi_ptr, $
   AGP_FOLDER = agp_folder, $
   AGP_VERSION = agp_version, $
   L1B2GM_FOLDER = l1b2gm_folder, $
   L1B2GM_VERSION = l1b2gm_version, $
   RCCM_FOLDER = rccm_folder, $
   RCCM_VERSION = rccm_version, $
   N_MASKS = n_masks, $
   ALSO_POOR = also_poor, $
   N_ATTEMPTS = n_attempts, $
   TEST_ID = test_id, $
   FIRST_LINE = first_line, $
   LAST_LINE = last_line, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   SAVE_IT = save_it, $
   SAVE_FOLDER = save_folder, $
   SCATT_IT = scatt_it, $
   SCATT_FOLDER = scatt_folder, $
   SET_MIN_SCATT = set_min_scatt, $
   SET_MAX_SCATT = set_max_scatt, $
   MAP_IT = map_it, $
   MAP_FOLDER = map_folder, $
   MAP_BRF = map_brf, $
   MAP_QUAL = map_qual, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function replaces missing and optionally poor values
   ;  in the L1B2 data buffers specified by the MISR MODE, PATH, ORBIT and
   ;  BLOCK by estimates based on the best linear fit equation with
   ;  another concurrent highly correlated data channel.
   ;
   ;  ALGORITHM: This function inspects and updates the MISR L1B2 data for
   ;  the specified MODE, PATH, ORBIT and BLOCK accessible through
   ;  pointers to heap variables, defines the clear land, clear water and
   ;  cloud masks (themselves corrected for missing values), computes the
   ;  best linear fit relations between the target L1B2 radiance data
   ;  channels that contain missing values and the other 35 available
   ;  source data channels for the same BLOCK, replaces the bad and
   ;  optionally poor data by the new estimates, optionally maps initial
   ;  and final products, and makes the fixed data buffers accessible
   ;  through new pointers (to heap variables) after optionally saving all
   ;  variables in an IDL save file.
   ;
   ;  SYNTAX: rc = fix_l1b2(misr_ptr, radrd_ptr, rad_ptr, brf_ptr,$
   ;  rdqi_ptr, scalf_ptr, convf_ptr, fixed_misr_ptr, fixed_radrd_ptr,$
   ;  fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr, $
   ;  AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
   ;  L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version,$
   ;  RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version,$
   ;  N_MASKS = n_masks, ALSO_POOR = also_poor, N_ATTEMPTS = n_attempts,$
   ;  TEST_ID = test_id, FIRST_LINE = first_line, LAST_LINE = last_line,$
   ;  LOG_IT = log_it, LOG_FOLDER = log_folder,$
   ;  SAVE_IT = save_it, SAVE_FOLDER = save_folder,$
   ;  SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder,$
   ;  SET_MIN_SCATT = set_min_scatt, SET_MAX_SCATT = set_max_scatt,$
   ;  MAP_IT = map_it, MAP_FOLDER = map_folder,$
   ;  MAP_BRF = map_brf, MAP_QUAL = map_qual,$
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_ptr {POINTER} [I]: The pointer to a STRING array containing
   ;      metadata on the MISR MODE, PATH, ORBIT and BLOCK of the next 4
   ;      pointer arrays.
   ;
   ;  *   radrd_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the UINT L1B2 scaled
   ;      radiance values (with the RDQI attached), in the native order
   ;      (DF/Blue to DA/NIR).
   ;
   ;  *   rad_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the FLOAT L1B2 unscaled
   ;      radiance values (hence without the RDQI attached), in the native
   ;      order (DF/Blue to DA/NIR).
   ;
   ;  *   brf_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the FLOAT L1B2 BRF values,
   ;      in the native order (DF/Blue to DA/NIR).
   ;
   ;  *   rdqi_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the BYTE L1B2 RDQI values,
   ;      in the native order (DF/Blue to DA/NIR).
   ;
   ;  *   scalf_ptr {POINTER array} [I]: The array of 36 DOUBLE scale
   ;      factors used to convert the unsigned 14-bit integer data into
   ;      radiance measurements, in units of W m^( − 2) sr^( − 1)
   ;      μm^( − 1).
   ;
   ;  *   convf_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      data buffers containing the FLOAT conversion factor arrays to
   ;      convert radiances into bidirectional reflectance factors.
   ;
   ;  *   fixed_misr_ptr {POINTER} [O]: The pointer to a STRING array
   ;      containing metadata on the MISR MODE, PATH, ORBIT and BLOCK of
   ;      the next 3 pointer arrays.
   ;
   ;  *   fixed_radrd_ptr {POINTER array} [O]: The array of 36 pointers to
   ;      the fixed MISR data buffers containing the UINT L1B2 scaled
   ;      radiance values (with the RDQI attached), in the native order
   ;      (DF/Blue to DA/NIR).
   ;
   ;  *   fixed_radrd_ptr {POINTER array} [O]: The array of 36 pointers to
   ;      the fixed MISR data buffers containing the UINT L1B2 unscaled
   ;      radiance values (hence without the RDQI attached), in the native
   ;      order (DF/Blue to DA/NIR).
   ;
   ;  *   fixed_brf_ptr {POINTER array} [O]: The array of 36 pointers to
   ;      the fixed MISR data buffers containing the FLOAT L1B2 BRF
   ;      values, in the native order (DF/Blue to DA/NIR).
   ;
   ;  *   fixed_rdqi_ptr {POINTER array} [O]: The array of 36 pointers to
   ;      the fixed MISR data buffers containing the BYTE L1B2 RDQI
   ;      values, in the native order (DF/Blue to DA/NIR).
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   AGP_FOLDER = agp_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR AGP files, if they are not located in the
   ;      default location.
   ;
   ;  *   AGP_VERSION = agp_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The AGP version identifier to use instead
   ;      of the default value.
   ;
   ;  *   L1B2GM_FOLDER = l1b2gm_folder {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 GM files, if they are not located in
   ;      the default location.
   ;
   ;  *   L1B2GM_VERSION = l1b2gm_version {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The L1B2 GM version identifier to use
   ;      instead of the default value.
   ;
   ;  *   RCCM_FOLDER = rccm_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR RCCM files, if they are not located in the
   ;      default location.
   ;
   ;  *   RCCM_VERSION = rccm_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The MISR RCCM version identifier to use
   ;      instead of the default value.
   ;
   ;  *   N_MASKS = n_masks {INT} [I] (Default value: 3): The number of
   ;      target types that need to be discriminated by the masks: 1 to
   ;      generate a single mask for all geophysical target types, 2 to
   ;      generate masks separately for land masses and water bodies, or 3
   ;      to generate masks separately for clear land masses, clear water
   ;      bodies and cloud fields.
   ;
   ;  *   ALSO_POOR = also_poor {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) replacing poor L1B2 values (i.e., those
   ;      with RDQI = 2B) by new estimates.
   ;
   ;  *   N_ATTEMPTS = n_attempts {INT} [I] (Default value: 1): Flag to
   ;      indicate the maximum number of ‘best’ linear fit equations can
   ;      be considered when trying to replace bad (missing) or optionally
   ;      poor L1B2 values.
   ;
   ;  *   TEST_ID = test_id {STRING} [I] (Default value: ”): String to
   ;      designate a particular experiment (e.g., to test the performance
   ;      of the algorithm), used in the filenames of the log, map and
   ;      scatterplot files.
   ;
   ;  *   FIRST_LINE = first_line {INT array of 36 elements} [I] (Default value: 36 elements set to -1):
   ;      The index (between 0 and 127 [for GM data] or 511 [for LM data])
   ;      of the first line to be replaced by missing data, in the
   ;      corresponding cameras and spectral bands. Values outside that
   ;      range are ignored.
   ;
   ;  *   LAST_LINE = last_line {INT array of 36 elements} [I] (Default value: 36 elements set to -1):
   ;      The index (between 0 and 127 [for GM data] or 511 [for LM data])
   ;      of the last line to be replaced by missing data, in the
   ;      corresponding cameras and spectral bands. Values outside that
   ;      range are ignored.
   ;
   ;  *   LOG_IT = log_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating a log file.
   ;
   ;  *   LOG_FOLDER = log_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the processing log.
   ;
   ;  *   SAVE_IT = save_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) saving the results in a savefile.
   ;
   ;  *   SAVE_FOLDER = save_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the savefile.
   ;
   ;  *   SCATT_IT = scatt_it {INT} [I] (Default value: 0): Flag to
   ;      generate (1) or skip (0) a scatterplot of the two best
   ;      correlated data channels for each of the cases specified by
   ;      n_masks.
   ;
   ;  *   SCATT_FOLDER = scatt_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the scatterplots.
   ;
   ;  *   SET_MIN_SCATT = set_min_scatt {STRING} [I] (Default value: None):
   ;      The minimum value to be used on the X and Y axes of the
   ;      scatterplots. WARNING: This value must be provided as a STRING
   ;      because the value 0.0 is frequently desirable as the minimum for
   ;      the scatterplot, but that numerical value would be
   ;      misinterpreted as NOT setting the keyword.
   ;
   ;  *   SET_MAX_SCATT = set_max_scatt {STRING} [I] (Default value: None):
   ;      The maximum value to be used on the X and Y axes of the
   ;      scatterplots. WARNING: By analogy with set_min_scatt, this value
   ;      must be provided as a STRING.
   ;
   ;  *   MAP_IT = map_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating maps of the clear land, clear water
   ;      and cloud masks.
   ;
   ;  *   MAP_FOLDER = map_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the maps.
   ;
   ;  *   MAP_BRF = map_brf {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating RGB and B&W maps of the L1B2 Brf
   ;      fields, before and after fixing.
   ;
   ;  *   MAP_QUAL = map_qual {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) generating maps of the L1B2 data
   ;      quality indicators (in particular RDQI, obscured and edge
   ;      pixels).
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) reporting progress on the console: 1 only
   ;      reports exiting the routine; 2 reports entering and exiting the
   ;      routine, as well as key milestones; 3 reports entering and
   ;      exiting the routine, and provides detailed information on the
   ;      intermediary results.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. Pointers to heap variables containing the
   ;      fixed L1B2 data buffers are provided as output positional
   ;      parameters, and the logs, maps and scatterplots are saved in the
   ;      default or designated folders, if requested.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. Output pointers may be undefined, and maps and other
   ;      outcomes may be inexistent, incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Warning 98: The computer has not been recognized by the function
   ;      get_host_info.pro.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 112: The input positional parameter radrd_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 114: The input positional parameter rad_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 116: The input positional parameter brf_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 118: The input positional parameter rdqi_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 120: The input positional parameter scalf_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 122: The input positional parameter convf_ptr is not a
   ;      pointer.
   ;
   ;  *   Error 130: The optional keyword parameter test_id is not of type
   ;      STRING.
   ;
   ;  *   Error 140: The optional input keyword parameter test_id is set
   ;      but the keyword parameter first_line is not set or invalid.
   ;
   ;  *   Error 150: The optional input keyword parameter test_id is set
   ;      but the keyword parameter last_line is not set or invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      orbit2date.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters agp_folder, rccm_folder,
   ;      log_folder, save_folder, map_folder is not specified.
   ;
   ;  *   Error 400: The output directory log_fpath is unwritable.
   ;
   ;  *   Error 410: The output directory save_fpath is unwritable.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      map_l1b2.pro.
   ;
   ;  *   Error 510: An exception condition occurred in function
   ;      heap_l1b2_block.pro.
   ;
   ;  *   Error 520: An exception condition occurred in function
   ;      mk_l1b2_masks.pro.
   ;
   ;  *   Error 530: An exception condition occurred in function
   ;      mk_l1b2_masks.pro.
   ;
   ;  *   Error 540: An exception condition occurred in function
   ;      pre_fix_l1b2.pro.
   ;
   ;  *   Error 550: An exception condition occurred in function
   ;      fix_poor_l1b2.pro.
   ;
   ;  *   Error 560: An exception condition occurred in function
   ;      fix_miss_l1b2.pro.
   ;
   ;  *   Error 570: An exception condition occurred in function
   ;      map_l1b2.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   fix_miss_l1b2.pro
   ;
   ;  *   fix_poor_l1b2.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   heap_l1b2_block.pro
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_pointer.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   map_l1b2.pro
   ;
   ;  *   mk_l1b2_masks.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   pre_fix_l1b2.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strcat.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   str2block.pro
   ;
   ;  *   str2orbit.pro
   ;
   ;  *   str2path.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: WARNING: If (1) the L1B2 data set to be upgraded is from
   ;      a Global Mode acquisition, (2) the target data channel is
   ;      available at the native resolution of 275 m, and (3) the best
   ;      source data channel is available at the reduced spatial
   ;      resolution of 1100 m, then the map of the upgraded L1B2 product
   ;      will appear fuzzier in those upgraded areas than in untouched
   ;      areas. This effect may be particularly noticeable if the L1B2
   ;      data product also contains a large number of poor data values
   ;      and the optional input keyword parameter ALSO_POOR is set to a
   ;      non-zero value.
   ;
   ;  *   NOTE 2: WARNING: In most cases, replacing bad or poor L1B2
   ;      values by best estimates should be feasible using the optimally
   ;      correlated source data channel. On rare occasions, the target
   ;      and the optimal source data channels may both contain bad or
   ;      poor values in the same location. Setting the optional keyword
   ;      parameter n_attempts to values larger than 1 allows the code to
   ;      consider the next best performing source data channels to
   ;      achieve the desired goal. This keyword is currently capped at 8
   ;      because the reliability of predicting equations beyond that
   ;      often becomes insufficient.
   ;
   ;  *   NOTE 3: The optional input keyword parameters L1B2GM_FOLDER and
   ;      L1B2GM_VERSION are not needed when processing Global Mode data.
   ;      However, the basic land, water and cloud cover masks are always
   ;      generated at the reduced resolution of 1100 m. Hence, when
   ;      processing Local Mode data with the input keyword parameter
   ;      n_masks set to 3 (i.e., requiring the identification of clear
   ;      land, clear water and cloudy areas), an additional call to the
   ;      function heap_l1b2_block is made to temporarily place the
   ;      required Global Mode data on the heap, and this step requires
   ;      access to the corresponding folder and version, if they are
   ;      different from the default values.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'GM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050L
   ;      IDL> misr_block = 110
   ;      IDL> verbose = 1
   ;      IDL> debug = 1
   ;      IDL> rc = heap_l1b2_block(misr_mode, misr_path, $
   ;         misr_orbit, misr_block, misr_ptr, radrd_ptr, $
   ;         rad_ptr, brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, $
   ;         L1B2GM_VERSION = l1b2gm_version, $
   ;         L1B2LM_FOLDER = l1b2lm_folder, $
   ;         L1B2LM_VERSION = l1b2lm_version, $
   ;         MISR_SITE = misr_site, VERBOSE = verbose, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> agp_folder = ''
   ;      IDL> agp_version = ''
   ;      IDL> l1b2gm_folder = ''
   ;      IDL> l1b2gm_version = ''
   ;      IDL> rccm_folder = ''
   ;      IDL> rccm_version = ''
   ;      IDL> n_masks = 3
   ;      IDL> also_poor = 0
   ;      IDL> n_attempts = 4
   ;      IDL> test_id = ''
   ;      IDL> log_it = 1
   ;      IDL> log_folder = ''
   ;      IDL> save_it = 1
   ;      IDL> save_folder = ''
   ;      IDL> scatt_it = 1
   ;      IDL> scatt_folder = ''
   ;      IDL> set_min_scatt = ''
   ;      IDL> set_max_scatt = ''
   ;      IDL> map_it = 1
   ;      IDL> map_folder = ''
   ;      IDL> map_brf = 1
   ;      IDL> map_qual = 1
   ;      IDL> verbose = 1
   ;      IDL> debug = 1
   ;      IDL> rc = fix_l1b2(misr_ptr, radrd_ptr, rad_ptr, $
   ;         brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, $
   ;         fixed_misr_ptr, fixed_radrd_ptr, fixed_rad_ptr, $
   ;         fixed_brf_ptr, fixed_rdqi_ptr, $
   ;         AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, $
   ;         L1B2GM_VERSION = l1b2gm_version, $
   ;         RCCM_FOLDER = rccm_folder, $
   ;         RCCM_VERSION = rccm_version, $
   ;         N_MASKS = n_masks, ALSO_POOR = also_poor, $
   ;         N_ATTEMPTS = n_attempts, TEST_ID = test_id, $
   ;         FIRST_LINE = first_line, LAST_LINE = last_line, $
   ;         LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;         SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
   ;         SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
   ;         SET_MIN_SCATT = set_min_scatt, $
   ;         SET_MAX_SCATT = set_max_scatt, $
   ;         MAP_IT = map_it, MAP_FOLDER = map_folder, $
   ;         MAP_BRF = map_brf, MAP_QUAL = map_qual, $
   ;         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc)
   ;      rc = 0
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel M. Verstraete, Linda A. Hunt and Veljko M.
   ;      Jovanovic (2019) Improving the usability of the MISR L1B2
   ;      Georectified Radiance Product (2000–present) in land surface
   ;      applications, _Earth System Science Data Discussions (ESSDD)_,
   ;      Vol. 2019, p. 1–31, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-210/ (DOI:
   ;      10.5194/essd-2019-210).
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–02–28: Version 0.9 — Initial release.
   ;
   ;  *   2019–03–06: Version 1.0 — Initial public release.
   ;
   ;  *   2019–03–08: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–19: Version 2.01 — Add the optional input keyword
   ;      parameter ALSO_POOR to enable the user to replace poor data
   ;      values in the same way as bad data values.
   ;
   ;  *   2019–03–20: Version 2.02 — Upgrade the code to allow the use of
   ;      the up to N_ATTEMPTS best statistical relations to replace the
   ;      bad (missing) or poor (if requested) values, in case the first
   ;      option is not applicable.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–04–06: Version 2.11 — Update the code to use the more
   ;      detailed masks generated by the latest versions of
   ;      mk_l1b2_masks.pro and best_fits_l1b2.pro.
   ;
   ;  *   2019–04–12: Version 2.12 — Update the code to use more explicit
   ;      variable names for storing the results of best fits.
   ;
   ;  *   2019–04–19: Version 2.13 — Simplify the code by forcing n_masks
   ;      to be 3, i.e., by always distinguishing between clear land
   ;      masses, clear water bodies and cloud fields, and add the
   ;      pointers to the original MISR data to the output positional
   ;      parameter list.
   ;
   ;  *   2019–04–24: Version 2.14 — Adjust the code to use the new
   ;      version of function heap_l1b2_block.pro which also returns the
   ;      conversion factors, add the optional input keyword parameter
   ;      N_MASKS, and add diagnostic information about the number of
   ;      unusable source values and the the number of unusable negative
   ;      replacement values in the log file.
   ;
   ;  *   2019–05–02: Version 2.15 — Bug fix: Encapsulate folder and file
   ;      creation in IF statements.
   ;
   ;  *   2019–06–11: Version 2.16 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–10: Version 2.17 — Update the code to externalize the
   ;      acquisition of L1B2 data (the function heap_l1b2_block.pro must
   ;      be called only once prior to processing RCCM, L1B2 or L1B3 data)
   ;      and to allow the processing of Local Mode data (which does
   ;      require an extra call to heap_l1b2_block.pro, as noted above).
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–09–17: Version 2.1.1 — Add the keywords TEST_ID, FIRST_LINE
   ;      and LAST_LINE to include additional information in the map
   ;      legends whenever missing data have been artificially inserted in
   ;      the L1B2 data buffers.
   ;
   ;  *   2019–09–28: Version 2.1.2 — Update the code to modify the
   ;      default log, map and savefile output directories, and use the
   ;      current version of the function hr2lr.pro.
   ;
   ;  *   2019–10–23: Version 2.1.3 — Major rewrite of the function
   ;      fix_l1b2.pro, breaking it up into smaller routines, including
   ;      this one, and optionally replacing poor values before processing
   ;      missing values.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
   ;
   ;  *   2020–05–02: Version 2.1.6 — Update the code to free all pointers
   ;      to heap variables that are generated in the course of the
   ;      processing but not returned as outputs; update the
   ;      documentation.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in their entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (~KEYWORD_SET(n_masks)) THEN BEGIN
      n_masks = 3
   ENDIF ELSE BEGIN
      IF (is_numeric(n_masks)) THEN BEGIN
         IF ((n_masks LT 1) OR (n_masks GT 3)) THEN n_masks = 3
      ENDIF ELSE BEGIN
         n_masks = 3
      ENDELSE
   ENDELSE
   IF (KEYWORD_SET(also_poor)) THEN also_poor = 1 ELSE also_poor = 0
   IF (KEYWORD_SET(n_attempts)) THEN BEGIN
      IF (is_numeric(n_attempts)) THEN n_attempts = FIX(n_attempts) $
         ELSE n_attempts = 1
      IF (n_attempts LT 1) THEN n_attempts = 1
      IF (n_attempts GT 8) THEN n_attempts = 8
   ENDIF ELSE n_attempts = 1
   IF (~KEYWORD_SET(test_id)) THEN BEGIN
      test_id = ''
      IF (test_id EQ '') THEN BEGIN
         first_line = MAKE_ARRAY(9, 4, /INTEGER, VALUE = -1)
         last_line = MAKE_ARRAY(9, 4, /INTEGER, VALUE = -1)
      ENDIF
   ENDIF
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
   IF (log_it) THEN main_log_it = 1 ELSE main_log_it = 0
   IF (KEYWORD_SET(save_it)) THEN save_it = 1 ELSE save_it = 0
   IF (KEYWORD_SET(map_it)) THEN map_it = 1 ELSE map_it = 0
   IF (KEYWORD_SET(map_brf)) THEN map_brf = 1 ELSE map_brf = 0
   IF (KEYWORD_SET(map_qual)) THEN map_qual = 1 ELSE map_qual = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 12
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_ptr, radrd_ptr, rad_ptr, ' + $
            'brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, fixed_misr_ptr, ' + $
            'fixed_radrd_ptr, fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_ptr' is not a pointer:
      IF (is_pointer(misr_ptr) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter misr_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'radrd_ptr' is not a pointer:
      IF (is_pointer(radrd_ptr) NE 1) THEN BEGIN
         error_code = 112
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter radrd_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'rad_ptr' is not a pointer:
      IF (is_pointer(rad_ptr) NE 1) THEN BEGIN
         error_code = 114
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter rad_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'brf_ptr' is not a pointer:
      IF (is_pointer(brf_ptr) NE 1) THEN BEGIN
         error_code = 116
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter brf_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'rdqi_ptr' is not a pointer:
      IF (is_pointer(rdqi_ptr) NE 1) THEN BEGIN
         error_code = 118
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter rdqi_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'scalf_ptr' is not a pointer:
      IF (is_pointer(scalf_ptr) NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter scalf_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'convf_ptr' is not a pointer:
      IF (is_pointer(convf_ptr) NE 1) THEN BEGIN
         error_code = 122
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter convf_ptr is not a pointer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter 'test_id' is set but not as a STRING:
      IF (KEYWORD_SET(test_id) AND (is_string(test_id) NE 1)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional keyword parameter test_id is not of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter 'test_id' is set and the keyword parameter 'first_line'
   ;  is not set, or not an INT array of 36 elements:
      IF ((test_id NE '') AND $
         ((is_integer(first_line) NE 1) OR $
         (is_array(first_line) NE 1) OR $
         (N_ELEMENTS(first_line) NE 36))) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional input keyword parameter test_id is set but ' + $
            'the keyword parameter first_line is not set or invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter 'test_id' is set and the keyword parameter 'last_line'
   ;  is not set, or not an INT array of 36 elements:
      IF ((test_id NE '') AND $
         ((is_integer(last_line) NE 1) OR $
         (is_array(last_line) NE 1) OR $
         (N_ELEMENTS(last_line) NE 36))) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The optional input keyword parameter test_id is set but ' + $
            'the keyword parameter last_line is not set or invalid.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   misr_cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames
   n_chns = misr_specs.NChannels
   misr_chns = misr_specs.ChannelNames

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 98
      excpt_cond = 'Warning ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
   ENDIF

   ;  Set the default folders and version identifiers of the MISR and
   ;  MISR-HR files on this computer, and return to the calling routine if
   ;  there is an internal error, but not if the computer is unrecognized, as
   ;  root addresses can be overridden by input keyword parameters:
   rc_roots = set_roots_vers(root_dirs, versions, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc_roots GE 100)) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the MISR and MISR-HR version numbers if they have not been specified
   ;  explicitly:
   IF (~KEYWORD_SET(agp_version)) THEN agp_version = versions[0]
   IF (~KEYWORD_SET(rccm_version)) THEN rccm_version = versions[5]

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Retrieve the MISR Mode, Path, Orbit, Block and Version identifiers from
   ;  the input positional parameter 'misr_ptr':
   temp = *misr_ptr
   misr_mode = temp[0]
   misr_path_str = temp[1]
   misr_orbit_str = temp[2]
   misr_block_str = temp[3]
   misr_version = temp[4]

   ;  Retrieve the numeric value of the MISR Path, Orbit and Block:
   rc = str2path(misr_path_str, misr_path)
   rc = str2orbit(misr_orbit_str, misr_orbit)
   rc = str2block(misr_block_str, misr_block)

   pob_str = strcat([misr_path_str, misr_orbit_str, misr_block_str], '-')
   mpob_str = strcat([misr_mode, pob_str], '-')

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (excpt_cond NE '')) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(agp_folder) OR $
         ~KEYWORD_SET(rccm_folder) OR $
         (log_it AND (~KEYWORD_SET(log_folder))) OR $
         (save_it AND (~KEYWORD_SET(save_folder))) OR $
         (map_it AND (~KEYWORD_SET(map_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And at least one of the optional input ' + $
            'keyword parameters agp_folder, rccm_folder, log_folder, ' + $
            'save_folder, map_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  If required, map the original L1B2 product before fixing:
   IF (map_brf OR map_qual) THEN BEGIN
      IF (verbose GT 0) THEN BEGIN
         PRINT, 'Start mapping the original L1B2 Brf product.'
         PRINT
      ENDIF
      IF (test_id EQ '') THEN BEGIN
         prefix = 'orig'
      ENDIF ELSE BEGIN
         prefix = test_id + '_orig'
      ENDELSE
      scl_rgb_min = 0.0
      scl_rgb_max = 0.0
      scl_nir_min = 0.0
      scl_nir_max = 0.0
      rgb_low = 1
      rgb_high = 1
      per_band = 1
      rc = map_l1b2(misr_ptr, radrd_ptr, brf_ptr, rdqi_ptr, $
         prefix, N_MASKS = n_masks, $
         SCL_RGB_MIN = scl_rgb_min, SCL_RGB_MAX = scl_rgb_max, $
         SCL_NIR_MIN = scl_nir_min, SCL_NIR_MAX = scl_nir_max, $
         RGB_LOW = rgb_low, RGB_HIGH = rgb_high, $
         PER_BAND = per_band, TEST_ID = test_id, $
         FIRST_LINE = first_line, LAST_LINE = last_line, $
         LOG_IT = log_it, LOG_FOLDER = log_folder, $
         MAP_BRF = map_brf, MAP_QUAL = map_qual, $
         MAP_FOLDER = map_folder, VERBOSE = verbose, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 500
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      IF (verbose GT 0) THEN BEGIN
         PRINT, 'Mapping the original L1B2 Brf product completed.'
         PRINT
      ENDIF
   ENDIF

   ;  Define the clear land, clear water and cloud masks. If the current
   ;  processing concerns Local Mode data, upload the Global Mode L1B2 data
   ;  on the heap for the purpose of processing RCCM data, then free those
   ;  pointers when not required anymore:
   IF ((misr_mode EQ 'LM') AND (n_masks EQ 3)) THEN BEGIN
      rc = heap_l1b2_block('GM', misr_path, misr_orbit, misr_block, $
         misrgm_ptr, radrdgm_ptr, radgm_ptr, brfgm_ptr, rdqigm_ptr, $
         scalfgm_ptr, convfgm_ptr, $
         L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 510
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

      rc = mk_l1b2_masks(misrgm_ptr, radrdgm_ptr, n_masks, lwc_mask_ptr, $
         AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
         RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
         MAP_IT = map_it, MAP_FOLDER = map_folder, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 520
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      PTR_FREE, misrgm_ptr, radrdgm_ptr, radgm_ptr, brfgm_ptr, rdqigm_ptr, $
         scalfgm_ptr, convfgm_ptr
   ENDIF ELSE BEGIN
      rc = mk_l1b2_masks(misr_ptr, radrd_ptr, n_masks, lwc_mask_ptr, $
         AGP_FOLDER = agp_folder, AGP_VERSION = agp_version, $
         RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
         MAP_IT = map_it, MAP_FOLDER = map_folder, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 530
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDELSE

   IF (verbose GT 0) THEN BEGIN
      PRINT
      PRINT, 'Generating the land/water/cloud masks completed.'
      PRINT
   ENDIF

   IF (log_it) THEN BEGIN

   ;  Set the directory address of the folder containing the output log file:
      IF (KEYWORD_SET(log_folder)) THEN BEGIN
         log_fpath = log_folder
      ENDIF ELSE BEGIN
         log_fpath = root_dirs[3] + pob_str + PATH_SEP() + $
            misr_mode + PATH_SEP() + 'L1B2' + PATH_SEP()
      ENDELSE
      rc = force_path_sep(log_fpath)

   ;  Check that the output directory 'log_fpath' exists and is writable, and
   ;  if not, create it:
      res = is_writable_dir(log_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory log_fpath is unwritable.'
         RETURN, error_code
      ENDIF

   ;  Generate the specification of the log file:
      IF (also_poor) THEN pindic = '-poor' ELSE pindic = '-nopoor'
      IF (test_id EQ '') THEN BEGIN
         log_fname = 'Log_L1B2_' + $
            'fixed-Brf-nm' + strstr(n_masks) + pindic + $
            '-na' + strstr(n_attempts) + '_' + mpob_str + '_' + $
            acquis_date + '_' + date + '.txt'
      ENDIF ELSE BEGIN
         log_fname = 'Log_L1B2_' + test_id + $
            '_fixed-Brf-nm' + strstr(n_masks) + pindic + $
            '-na' + strstr(n_attempts) + '_' + mpob_str + '_' + $
            acquis_date + '_' + date + '.txt'
      ENDELSE
      log_fspec = log_fpath + log_fname

      fmt1 = '(A30, A)'

      OPENW, main_log_unit, log_fspec, /GET_LUN
      PRINTF, main_log_unit, 'File name: ', FILE_BASENAME(log_fspec), $
         FORMAT = fmt1
      PRINTF, main_log_unit, 'Folder name: ', FILE_DIRNAME(log_fspec, $
         /MARK_DIRECTORY), FORMAT = fmt1
      PRINTF, main_log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, main_log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, main_log_unit, 'Saved on: ', date_time, FORMAT = fmt1
      PRINTF, main_log_unit

      PRINTF, main_log_unit, 'Content: ', 'Log of the L1B2 fixing process' , $
         FORMAT = fmt1
      PRINTF, main_log_unit
      PRINTF, main_log_unit, 'MISR Mode: ', misr_mode, FORMAT = fmt1
      PRINTF, main_log_unit, 'MISR Path: ', strstr(misr_path), FORMAT = fmt1
      PRINTF, main_log_unit, 'MISR Orbit: ', strstr(misr_orbit), FORMAT = fmt1
      PRINTF, main_log_unit, 'MISR Block: ', strstr(misr_block), FORMAT = fmt1
      PRINTF, main_log_unit, 'Date of MISR acquisition: ', acquis_date, $
         FORMAT = fmt1
      PRINTF, main_log_unit
      PRINTF, main_log_unit, 'Optional keyword N_MASKS: ', $
         strstr(n_masks), FORMAT = fmt1
      PRINTF, main_log_unit, 'Optional keyword ALSO_POOR: ', $
         strstr(also_poor), FORMAT = fmt1
      PRINTF, main_log_unit, 'Optional keyword N_ATTEMPTS: ', $
         strstr(n_attempts), FORMAT = fmt1
      PRINTF, main_log_unit
      IF (test_id NE '') THEN BEGIN
         PRINTF, main_log_unit, 'test_id: ', test_id, FORMAT = fmt1
         FOR i = 0, n_cams - 1 DO BEGIN
            FOR j = 0, n_bnds - 1 DO BEGIN
               IF (first_line[i, j] NE -1) THEN BEGIN
                  PRINTF, main_log_unit, 'Missing data inserted in: ', $
                     misr_cams[i] + ' and ' + misr_bnds[j], FORMAT = fmt1
                  PRINTF, main_log_unit, '', $
                     'from ' + strstr(first_line[i, j]) + $
                     ' to ' + strstr(last_line[i, j]), FORMAT = fmt1
               ENDIF
            ENDFOR
         ENDFOR
         PRINTF, main_log_unit
      ENDIF
   ENDIF

   ;  Detect the presence of poor and missing values in the input databuffers
   ;  and document their numbers and locations:
   rc = pre_fix_l1b2(misr_ptr, radrd_ptr, rad_ptr, rdqi_ptr, $
      lwc_mask_ptr, n_poor_lnd_ptr, idx_poor_lnd_ptr, $
      n_poor_wat_ptr, idx_poor_wat_ptr, $
      n_poor_cld_ptr, idx_poor_cld_ptr, $
      n_miss_lnd_ptr, idx_miss_lnd_ptr, $
      n_miss_wat_ptr, idx_miss_wat_ptr, $
      n_miss_cld_ptr, idx_miss_cld_ptr, $
      best_fits_ptr, N_MASKS = n_masks, $
      ALSO_POOR = also_poor, TEST_ID = test_id, $
      MAIN_LOG_IT = main_log_it, MAIN_LOG_UNIT = main_log_unit, $
      LOG_IT = log_it, LOG_FOLDER = log_folder, $
      SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
      SET_MIN_SCATT = set_min_scatt, SET_MAX_SCATT = set_max_scatt, $
      VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (rc NE 0) THEN BEGIN
      error_code = 540
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Define the output arrays of pointers to the fixed L1B2 data buffers to be
   ;  placed on the heap:
   fixed_misr_ptr = misr_ptr
   fixed_radrd_ptr = PTRARR(n_cams, n_bnds)
   fixed_rad_ptr = PTRARR(n_cams, n_bnds)
   fixed_brf_ptr = PTRARR(n_cams, n_bnds)
   fixed_rdqi_ptr = PTRARR(n_cams, n_bnds)

   ;  Load the original databuffers into the fixed databuffers (default values
   ;  if nothing needs fixing; these will be reset if poor or bad values are
   ;  subsequently updated in some of the databuffers):
   FOR cam = 0, n_cams - 1 DO BEGIN
      FOR bnd = 0, n_bnds - 1 DO BEGIN
         fixed_radrd_ptr[cam, bnd] = radrd_ptr[cam, bnd]
         fixed_rad_ptr[cam, bnd] = rad_ptr[cam, bnd]
         fixed_brf_ptr[cam, bnd] = brf_ptr[cam, bnd]
         fixed_rdqi_ptr[cam, bnd] = rdqi_ptr[cam, bnd]
      ENDFOR
   ENDFOR

   ;  If required, update the poor data values:
   IF (also_poor) THEN BEGIN
      rc = fix_poor_l1b2(misr_ptr, radrd_ptr, rad_ptr, brf_ptr, rdqi_ptr, $
         scalf_ptr, convf_ptr, lwc_mask_ptr, fixed_misr_ptr, fixed_radrd_ptr, $
         fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr, n_poor_lnd_ptr, $
         idx_poor_lnd_ptr, n_poor_wat_ptr, idx_poor_wat_ptr, n_poor_cld_ptr, $
         idx_poor_cld_ptr, best_fits_ptr, N_MASKS = n_masks, $
         N_ATTEMPTS = n_attempts, $
         MAIN_LOG_IT = main_log_it, MAIN_LOG_UNIT = main_log_unit, $
         SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 550
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Update the missing data values. If the poor values have previously been
   ;  replaced by estimates, then call this function with the fixed data
   ;  buffers as input, otherwise use the original values:
   IF (also_poor) THEN BEGIN
      rc = fix_miss_l1b2(misr_ptr, fixed_radrd_ptr, fixed_rad_ptr, $
         fixed_brf_ptr, fixed_rdqi_ptr, $
         scalf_ptr, convf_ptr, lwc_mask_ptr, fixed_misr_ptr, fixed_radrd_ptr, $
         fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr, n_miss_lnd_ptr, $
         idx_miss_lnd_ptr, n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr, $
         idx_miss_cld_ptr, best_fits_ptr, N_MASKS = n_masks, $
         N_ATTEMPTS = n_attempts, $
         MAIN_LOG_IT = main_log_it, MAIN_LOG_UNIT = main_log_unit, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 560
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE BEGIN
      rc = fix_miss_l1b2(misr_ptr, radrd_ptr, rad_ptr, brf_ptr, rdqi_ptr, $
         scalf_ptr, convf_ptr, lwc_mask_ptr, fixed_misr_ptr, fixed_radrd_ptr, $
         fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr, n_miss_lnd_ptr, $
         idx_miss_lnd_ptr, n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr, $
         idx_miss_cld_ptr, best_fits_ptr, N_MASKS = n_masks, $
         N_ATTEMPTS = n_attempts, $
         MAIN_LOG_IT = main_log_it, MAIN_LOG_UNIT = main_log_unit, $
         VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 562
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDELSE

   ;  If required, map the fixed L1B2 product after fixing:
   IF (map_brf OR map_qual) THEN BEGIN
      IF (verbose GT 0) THEN BEGIN
         PRINT, 'Start mapping the fixed L1B2 Brf product.'
         PRINT
      ENDIF
      IF (test_id EQ '') THEN BEGIN
         prefix = 'fixed-na' + strstr(n_attempts)
      ENDIF ELSE BEGIN
         prefix = test_id + '_fixed-na' + strstr(n_attempts)
      ENDELSE

      rc = map_l1b2(misr_ptr, fixed_radrd_ptr, fixed_brf_ptr, fixed_rdqi_ptr, $
         prefix, N_MASKS = n_masks, $
         SCL_RGB_MIN = scl_rgb_min, SCL_RGB_MAX = scl_rgb_max, $
         SCL_NIR_MIN = scl_nir_min, SCL_NIR_MAX = scl_nir_max, $
         RGB_LOW = rgb_low, RGB_HIGH = rgb_high, $
         PER_BAND = per_band, TEST_ID = test_id, $
         FIRST_LINE = first_line, LAST_LINE = last_line, $
         LOG_IT = log_it, LOG_FOLDER = log_folder, $
         MAP_BRF = map_brf, MAP_QUAL = map_qual, $
         MAP_FOLDER = map_folder, VERBOSE = verbose, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 570
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      IF (verbose GT 0) THEN BEGIN
         PRINT, 'Mapping the fixed L1B2 Brf product completed.'
         PRINT
      ENDIF

   ENDIF

   ;  Save the final result in an IDL SAVE file if requested:
   IF (save_it) THEN BEGIN

      IF (KEYWORD_SET(save_folder)) THEN BEGIN
         save_fpath = save_folder
      ENDIF ELSE BEGIN
         save_fpath = root_dirs[3] + pob_str + PATH_SEP() + $
            misr_mode + PATH_SEP() + 'L1B2' + PATH_SEP() + 'Save_L1B2'

   ;  Update the save path if this is a test run:
         IF (test_id NE '') THEN save_fpath = save_fpath + '_' + test_id
      ENDELSE
      rc = force_path_sep(save_fpath)

   ;  Create the output directory 'save_fpath' if it does not exist, and
   ;  return to the calling routine with an error message if it is unwritable:
      res = is_writable_dir(save_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 410
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory save_fpath is unwritable.'
         RETURN, error_code
      ENDIF

      IF (test_id EQ '') THEN BEGIN
         save_fname = 'Save_L1B2_' + mpob_str + '_' + acquis_date + '_' + $
            date + '.sav'
      ENDIF ELSE BEGIN
         save_fname = 'Save_L1B2_' + mpob_str + '_' + acquis_date + '_' + $
            date + '_' + test_id + '.sav'
      ENDELSE
      save_fspec = save_fpath + save_fname
      SAVE, /ALL, FILENAME = save_fspec

      IF (log_it) THEN BEGIN
         PRINTF, main_log_unit, 'Final updated and upgraded L1B2 data saved in'
         PRINTF, main_log_unit, save_fspec
         PRINTF, main_log_unit
      ENDIF
   ENDIF

   ;  Free all pointers to heap variables that are not returned as output
   ;  parameters:
   PTR_FREE, lwc_mask_ptr
   PTR_FREE, n_poor_lnd_ptr, idx_poor_lnd_ptr
   PTR_FREE, n_poor_wat_ptr, idx_poor_wat_ptr
   PTR_FREE, n_poor_cld_ptr, idx_poor_cld_ptr
   PTR_FREE, n_miss_lnd_ptr, idx_miss_lnd_ptr
   PTR_FREE, n_miss_wat_ptr, idx_miss_wat_ptr
   PTR_FREE, n_miss_cld_ptr, idx_miss_cld_ptr
   PTR_FREE, best_fits_ptr

   IF (log_it) THEN BEGIN
      CLOSE, main_log_unit
      FREE_LUN, main_log_unit
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
