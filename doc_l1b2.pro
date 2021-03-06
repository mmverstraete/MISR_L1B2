PRO doc_l1b2, $
   misr_mode, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   L1B2_FOLDER = l1b2_folder, $
   L1B2_VERSION = l1b2_version, $
   MISR_SITE = misr_site, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   SAVE_IT = save_it, $
   SAVE_FOLDER = save_folder, $
   HIST_IT = hist_it, $
   HIST_FOLDER = hist_folder, $
   MAP_IT = map_it, $
   MAP_FOLDER = map_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;l1b2gm_files
   ;
   ;  PURPOSE: This procedure generates histograms and maps of the data
   ;  contained in the standard MISR L1B2 Georectified Radiance Product
   ;  (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance files
   ;  corresponding to the specified input positional parameters MODE,
   ;  PATH, ORBIT and BLOCK.
   ;
   ;  ALGORITHM: This procedure calls the functions diag_l1b2.proand
   ;  map_l1b2.pro to generate the required histograms and maps
   ;  corresponding to the specified input positional parameters MODE,
   ;  PATH, ORBIT and BLOCK. and BLOCK.
   ;
   ;  SYNTAX: doc_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   ;  L1B2_FOLDER = l1b2_folder, L1B2_VERSION = l1b2_version, $
   ;  MISR_SITE = misr_site, $
   ;  LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;  SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
   ;  HIST_IT = hist_it, HIST_FOLDER = hist_folder, $
   ;  MAP_IT = map_it, MAP_FOLDER = map_folder, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   L1B2_FOLDER = l1b2_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 files, if they are not located in the
   ;      default location.
   ;
   ;  *   L1B2_VERSION = l1b2_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The L1B2 version identifier to use instead
   ;      of the default value.
   ;
   ;  *   MISR_SITE = misr_site {STRING} [I] (Default value: None: The
   ;      official name of the Local Mode site.
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
   ;  *   HIST_IT = hist_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating histograms of the numerical results.
   ;
   ;  *   HIST_FOLDER = hist_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the histograms.
   ;
   ;  *   MAP_IT = map_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating maps of the numerical results.
   ;
   ;  *   MAP_FOLDER = map_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the maps.
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
   ;  RETURNED VALUE TYPE: N/A.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, the keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call. The
   ;      number of output files generated depends on the settings of the
   ;      optional input keyword parameters log_it, save_it, hist_it and
   ;      map_it. Customized outputs can be generated by calling those
   ;      functions diag_l1b2.pro, map_l1b2_block.pro and
   ;      map_l1b2_miss.pro individually. See the documentation of these
   ;      functions for further details.
   ;
   ;  *   If an exception condition has been detected, the optional output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered, if the optional input keyword
   ;      parameter DEBUG is set and if the optional output keyword
   ;      parameter EXCPT_COND is provided. This program prints an error
   ;      message and returns control to the calling program or to the
   ;      console; the expected output files may be inexistent, incomplete
   ;      or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input argument misr_mode is invalid.
   ;
   ;  *   Error 120: Input argument misr_path is invalid.
   ;
   ;  *   Error 130: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 132: The input positional parameter misr_orbit is
   ;      inconsistent with the input positional parameter misr_path.
   ;
   ;  *   Error 134: An exception condition occurred in is_frompath.pro.
   ;
   ;  *   Error 136: Unexpected return code received from is_frompath.pro.
   ;
   ;  *   Error 140: Input argument misr_block is invalid.
   ;
   ;  *   Error 150: Attempt to process Local Mode data while misr_site is
   ;      an empty string.
   ;
   ;  *   Error 160: Attempt to process Local Mode data while misr_site is
   ;      undefined.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in function
   ;      heap_l1b2_block.pro.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      heap_l1b2_block.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   diag_l1b2.pro
   ;
   ;  *   first_char.pro
   ;
   ;  *   heap_l1b2_block.pro
   ;
   ;  *   is_defined.pro
   ;
   ;  *   is_frompath.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   map_l1b2.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This program calls the mapping functions with the
   ;      default scaling options. To generate maps with other settings,
   ;      call those functions individually.
   ;
   ;  *   NOTE 2: This program also reports on the time spent on each of
   ;      the main routines it calls to generate the desired outcomes.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> doc_l1b2, 'GM', 168, 68050, 110, $
   ;         /LOG_IT, /SAVE_IT, /HIST_IT, /MAP_IT, $
   ;         VERBOSE = 0, /DEBUG, EXCPT_COND = excpt_cond
   ;
   ;      results in the creation of all output files generated by the functions
   ;      diag_l1b2, map_l1b2_block and map_l1b2_miss.
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
   ;  *   Michel M. Verstraete, Linda A. Hunt and Veljko M.
   ;      Jovanovic (2020) Multi-angle Imaging SpectroRadiometer (MISR)
   ;      L1B2 Georectified Radiance Product (2000–present) in land surface
   ;      applications, _Earth System Science Data (ESSD)_, Vol. 12,
   ;      p. 1321-1346, available from
   ;      https://www.earth-syst-sci-data-discuss.net/essd-2019-210/
   ;      (DOI: 10.5194/essd-12-1321-2020).
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–24: Version 0.8 — Initial release under the name
   ;      doc_l1b2.
   ;
   ;  *   2017–10–10: Version 0.9 — Renamed the function to
   ;      doc_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–04–20: Version 1.1 — Update the documentation to refer to
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–06–01: Version 1.2 — Merge this function with its twin
   ;      doc_l1b2_lm.pro and change the name to doc_l1b2_block.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–24: Version 1.6 — Update the code to call the new
   ;      versions of other routines.
   ;
   ;  *   2019–02–17: Version 1.7 — Simplify this program to focus
   ;      exclusively on documenting the standard MISR L1B2 data through
   ;      histograms and maps.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–04–11: Version 2.11 — Bug fix: Corrected return statements;
   ;      use the function map_l1b2.pro rather than the deprecated
   ;      functions map_l1b2_block.pro and map_l1b2_miss.pro.
   ;
   ;  *   2019–05–02: Version 2.12 — Bug fix: Update RETURN statement
   ;      after the call to heap_l1b2_block and update the handling of
   ;      responses to run-time questions.
   ;
   ;  *   2019–06–11: Version 2.13 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–12–19: Version 2.1.1 — Bug fix (replace RETURN by STOP
   ;      statements) and code update to call the current versions of
   ;      diag_l1b2gm.pro and diag_l1b2lm.pro, and to set the value of
   ;      prefix before calling map_l1b2.pro.
   ;
   ;  *   2020–03–28: Version 2.1.2 — Add the optional keyword parameter
   ;      MISR_SITE to allow processing Local Mode data, and update the
   ;      documentation.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
   ;
   ;  *   2020–05–02: Version 2.1.6 — Update the code to free all heap
   ;      variables before ending the processing.
   ;
   ;  *   2020–05–10: Version 2.1.7 — Software version described in the
   ;      peer-reviewed paper published in _ESSD_ referenced above.
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

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
   IF (KEYWORD_SET(save_it)) THEN save_it = 1 ELSE save_it = 0
   IF (KEYWORD_SET(hist_it)) THEN hist_it = 1 ELSE hist_it = 0
   IF (KEYWORD_SET(map_it)) THEN map_it = 1 ELSE map_it = 0
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      IF (is_numeric(verbose)) THEN verbose = FIX(verbose) ELSE verbose = 0
      IF (verbose LT 0) THEN verbose = 0
      IF (verbose GT 3) THEN verbose = 3
   ENDIF ELSE verbose = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (verbose GT 1) THEN PRINT, 'Entering ' + rout_name + '.'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, misr_path, misr_orbit, ' + $
            'misr_block.'
         PRINT, error_code
         STOP
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_mode' is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         STOP
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         STOP
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         STOP
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is inconsistent with the input
   ;  positional parameter 'misr_path':
      res = is_frompath(misr_path, misr_orbit, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (res NE 1) THEN BEGIN
         CASE 1 OF
            (res EQ 0): BEGIN
               error_code = 132
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': The input positional parameter ' + $
                  'misr_orbit is inconsistent with the input positional ' + $
                  'parameter misr_path.'
               PRINT, error_code
               STOP
            END
            (res EQ -1): BEGIN
               error_code = 134
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               PRINT, error_code
               STOP
            END
            ELSE: BEGIN
               error_code = 136
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Unexpected return code ' + strstr(res) + $
                  ' from is_frompath.pro.'
               PRINT, error_code
               STOP
            END
         ENDCASE
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         STOP
      ENDIF

   ;  Return to the calling routine with an error message if the optional
   ;  keyword parameter MISR_SITE is empty or undefined while processing
   ;  Local Mode data:
      IF (misr_mode EQ 'LM') THEN BEGIN
         IF (is_defined(misr_site)) THEN BEGIN
            IF (misr_site EQ '') THEN BEGIN
               error_code = 150
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Attempt to process Local Mode data ' + $
                  "while misr_site = ''."
               PRINT, error_code
               STOP
            ENDIF
         ENDIF ELSE BEGIN
            error_code = 160
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
               rout_name + ': Attempt to process Local Mode data ' + $
               'while misr_site is undefined.'
            PRINT, error_code
            STOP
         ENDELSE
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames
   n_bands = misr_specs.NBands
   bands = misr_specs.BandNames

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
      PRINT, error_code
      STOP
   ENDIF

   ;  Set the MISR and MISR-HR version numbers if they have not been specified
   ;  explicitly:
   IF (misr_mode EQ 'GM') THEN BEGIN
      IF (~KEYWORD_SET(l1b2_version)) THEN l1b2_version = versions[2]
   ENDIF ELSE BEGIN
      IF (~KEYWORD_SET(l1b2_version)) THEN l1b2_version = versions[3]
   ENDELSE

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   ;  Generate the long string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   ;  Generate the long string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   ;  Load the 36 L1B2 data channels on the heap:
   rc = heap_l1b2_block(misr_mode, misr_path, misr_orbit, misr_block, $
      misr_ptr, radrd_ptr, rad_ptr, brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, $
      L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
      L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
      MISR_SITE = misr_site, VERBOSE = verbose, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 320
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   IF (verbose GT 0) THEN BEGIN
      PRINT
      PRINT, 'Documenting the MISR L1B2 ' + misr_mode + ' data for Path ' + $
         misr_path_str + ', Orbit ' + misr_orbit_str + ' and Block ' + $
         misr_block_str + '.'
      PRINT
      PRINT, '1. Collecting diagnostic information (metadata):'
      clock1 = TIC('Step 1')
   ENDIF

   ;  Collect diagnostic information (metadata) on this Block:
   CASE misr_mode OF
      'GM': BEGIN
         rc = diag_l1b2gm(misr_path, misr_orbit, misr_block, $
            L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
            LOG_IT = log_it, LOG_FOLDER = log_folder, $
            SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
            HIST_IT = hist_it, HIST_FOLDER = hist_folder, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (rc NE 0) THEN BEGIN
            PRINT, '*** WARNING ***'
            PRINT, 'Upon return from diag_l1b2gm, excpt_cond = ' + excpt_cond
            answ = ''
            READ, answ, PROMPT = 'Do you wish to continue (Y/N): '
            IF (STRUPCASE(first_char(strstr(answ))) NE 'Y') THEN STOP
         ENDIF
      END
      'LM': BEGIN
         rc = diag_l1b2lm(misr_site, misr_path, misr_orbit, misr_block, $
            L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
            LOG_IT = log_it, LOG_FOLDER = log_folder, $
            SAVE_IT = save_it, SAVE_FOLDER = save_folder, $
            HIST_IT = hist_it, HIST_FOLDER = hist_folder, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (rc NE 0) THEN BEGIN
            PRINT, '*** WARNING ***'
            PRINT, 'Upon return from diag_l1b2lm, excpt_cond = ' + excpt_cond
            answ = ''
            READ, answ, PROMPT = 'Do you wish to continue (Y/N): '
            IF (STRUPCASE(first_char(strstr(answ))) NE 'Y') THEN STOP
         ENDIF
      END
   ENDCASE

   IF (verbose GT 0) THEN BEGIN
      TOC, clock1
      PRINT
      PRINT, '2. Mapping the L1B2 data channels:'
      clock2 = TIC('Step 2')
   ENDIF

   ;  Map the L1B2 data channels, using the default scaling factors:
   prefix = 'doc'
   scl_rgb_min = 0.0
   scl_rgb_max = 0.0
   scl_nir_min = 0.0
   scl_nir_max = 0.0
   rgb_low = 1
   rgb_high = 1
   per_band = 1
   map_brf = 1
   map_qual = 1
   per_band = 1
   rc = map_l1b2(misr_ptr, radrd_ptr, brf_ptr, rdqi_ptr, $
      prefix, N_MASKS = n_masks, $
      SCL_RGB_MIN = scl_rgb_min, SCL_RGB_MAX = scl_rgb_max, $
      SCL_NIR_MIN = scl_nir_min, SCL_NIR_MAX = scl_nir_max, $
      RGB_LOW = rgb_low, RGB_HIGH = rgb_high, PER_BAND = per_band, $
      LOG_IT = log_it, LOG_FOLDER = log_folder, $
      MAP_BRF = map_brf, MAP_QUAL = map_qual, MAP_FOLDER = map_folder, $
      VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (excpt_cond NE '') THEN BEGIN
      PRINT, '*** WARNING ***'
      PRINT, 'Upon return from map_l1b2, excpt_cond = ' + excpt_cond
      answ = ''
      READ, answ, PROMPT = 'Do you wish to continue (Y/N): '
      IF (STRUPCASE(first_char(strstr(answ))) NE 'Y') THEN STOP
   ENDIF

   ;  Release the heap variables:
   PTR_FREE, misr_ptr, radrd_ptr, rad_ptr, brf_ptr, rdqi_ptr, scalf_ptr, $
      convf_ptr

   IF (verbose GT 0) THEN BEGIN
      TOC, clock2
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

END
