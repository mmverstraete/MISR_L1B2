FUNCTION heap_l1b2_block, $
   misr_mode, $
   misr_path, $
   misr_orbit, $
   misr_block, $
   misr_ptr, $
   radrd_ptr, $
   rad_ptr, $
   brf_ptr, $
   rdqi_ptr, $
   scalf_ptr, $
   convf_ptr, $
   L1B2GM_FOLDER = l1b2gm_folder, $
   L1B2GM_VERSION = l1b2gm_version, $
   L1B2LM_FOLDER = l1b2lm_folder, $
   L1B2LM_VERSION = l1b2lm_version, $
   MISR_SITE = misr_site, $
   TEST_ID = test_id, $
   FIRST_LINE = first_line, $
   LAST_LINE = last_line, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function provides convenient global access to the MISR
   ;  L1B2 GRP data contained in the 9 files specified by the input
   ;  positional parameters misr_mode, misr_path, misr_orbit, and
   ;  misr_block. It can also optionally insert missing data in one or
   ;  more of those files for testing purposes.
   ;
   ;  ALGORITHM: This function reads the various data fields contained in
   ;  the MISR L1B2 GRP files specified by the input positional parameters
   ;  and makes them available through globally accessible pointers on the
   ;  heap. If the optional keyword parameter test_id is not a null
   ;  string, this function saves the original L1B2 data and replaces
   ;  missing data
   ;
   ;  SYNTAX: rc = heap_l1b2_block(misr_mode, misr_path, misr_orbit, $
   ;  misr_block, misr_ptr, radrd_ptr, rad_ptr, $
   ;  brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, $
   ;  L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;  L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
   ;  MISR_SITE = misr_site, TEST_ID = test_id, $
   ;  FIRST_LINE = first_line, LAST_LINE = last_line, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INT} [I]: The selected MISR BLOCK number.
   ;
   ;  *   misr_ptr {POINTER} [O]: The pointer to a 4-elements STRING array
   ;      where misr_ptr [0] contains the MISR MODE, misr_ptr [1] contains
   ;      the PATH number, misr_ptr [2] contains the ORBIT number, and
   ;      misr_ptr [3] contains the BLOCK number.
   ;
   ;  *   radrd_ptr {POINTER array} [O]: The 36-elements pointer array to
   ;      UINT arrays containing the 16 bit L1B2 scaled radiance values
   ;      (with the RDQI attached), in the native order (DF/Blue to
   ;      DA/NIR).
   ;
   ;  *   rad_ptr {POINTER array} [O]: The 36-elements pointer array to
   ;      FLOAT arrays containing the 32 bit L1B2 unscaled radiance
   ;      values, in the native order (DF/Blue to DA/NIR).
   ;
   ;  *   brf_ptr {POINTER array} [O]: The 36-elements pointer array to
   ;      FLOAT arrays containing the 32 bit L1B2 bidirectional
   ;      reflectance factors, in the native order (DF/Blue to DA/NIR).
   ;
   ;  *   rdqi_ptr {POINTER array} [O]: The 36-elements pointer array to
   ;      BYTE arrays containing the 8 bit L1B2 RDQI values, in the native
   ;      order (DF/Blue to DA/NIR).
   ;
   ;  *   scalf_ptr {POINTER array} [O]: The 36-elements pointer array to
   ;      DOUBLE (precision) 64 bit scale factors used to convert the
   ;      unsigned 14-bit integer data into radiance measurements, in
   ;      units of W m^( − 2) sr^( − 1) μm^( − 1):
   ;      _Radiance (FLOAT) = Scaled radiance (UINT)× scale_factor
   ;      (DOUBLE)_
   ;
   ;  *   convf_ptr {POINTER array} [O]: The 36-elements pointer array to
   ;      FLOAT arrays containing the 32 bit conversion factors used to
   ;      convert radiances into bidirectional reflectance factors:
   ;      _Brf (FLOAT) = Radiance (FLOAT)× conversion_factor_
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
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
   ;  *   L1B2LM_FOLDER = l1b2lm_folder {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 LM files, if they are not located in
   ;      the default location.
   ;
   ;  *   L1B2LM_VERSION = l1b2lm_version {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The L1B2 LM version identifier to use
   ;      instead of the default value.
   ;
   ;  *   MISR_SITE = misr_site {STRING} [I] (Default value: None): The
   ;      selected MISR Local Mode Site name.
   ;
   ;  *   TEST_ID = test_id {STRING} [I] (Default value: ”): Flag to
   ;      activate (non-empty STRING) or skip (empty STRING) artificially
   ;      introducing missing data in the L1B2 data buffer; if set, this
   ;      keyword is used in output file names to label experiments.
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
   ;      provided in the call. The MISR L1B2 data buffers are loaded on
   ;      the heap and globally reachable through pointers, within the
   ;      current program.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The MISR L1B2 data buffers may not have been loaded on
   ;      the heap.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_mode is invalid.
   ;
   ;  *   Error 120: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 130: The input positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 132: The input positional parameter misr_orbit is
   ;      inconsistent with the input positional parameter misr_path.
   ;
   ;  *   Error 134: An exception condition occurred in is_frompath.pro.
   ;
   ;  *   Error 136: Unexpected return code received from is_frompath.pro.
   ;
   ;  *   Error 140: The input positional parameter misr_block is invalid.
   ;
   ;  *   Error 150: Local Mode data are requested but the keyword
   ;      parameter MISR_SITE is not specified.
   ;
   ;  *   Error 160: The optional keyword parameter test_id is not of type
   ;      STRING.
   ;
   ;  *   Error 170: The optional input keyword parameter test_id is set
   ;      but the keyword parameter first_line is not set or invalid.
   ;
   ;  *   Error 180: The optional input keyword parameter test_id is set
   ;      but the keyword parameter last_line is not set or invalid.
   ;
   ;  *   Error 190: At least one of the couples (first_line, last_line)
   ;      is inconsistent.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      find_l1b2gm_files.pro.
   ;
   ;  *   Error 310: An exception condition occurred in function
   ;      find_l1b2lm_files.pro.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 510: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 520: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading one of the l1b2_files to extract the
   ;      scaled Radiance/RDQI values.
   ;
   ;  *   Error 620: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading one of the l1b2_files to extract the
   ;      unscaled Radiance values.
   ;
   ;  *   Error 630: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading one of the l1b2_files to extract the
   ;      Brf values.
   ;
   ;  *   Error 640: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading one of the l1b2_files to extract the
   ;      RDQI values.
   ;
   ;  *   Error 650: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_GRIDATTR_GET.
   ;
   ;  *   Error 660: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading one of the l1b2_files to extract the
   ;      BRF Conversion Factor values.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
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
   ;  *   find_l1b2gm_files.pro
   ;
   ;  *   find_l1b2lm_files.pro
   ;
   ;  *   is_frompath.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function loads all main data fields for each of the
   ;      36 L1B2 data channels (9 cameras by 4 spectral bands)
   ;      corresponding to a MISR MODE, PATH, ORBIT, and BLOCK on the heap
   ;      and makes them globally available through pointers. For
   ;      instance,
   ;
   ;      -   The data buffer containing the scaled radiance (with the
   ;          RDQI attached) values for the CF camera in the NIR spectral
   ;          band is accessible as rad_cf_nir = *radrd_ptr[1, 3], where
   ;          the index 1 refers to the second camera (CF) and where the
   ;          index 3 refers to the fourth spectral band (NIR).
   ;
   ;      -   A particular pixel value (e.g., at location [203, 52])
   ;          within that data buffer is then accessed as if the buffer
   ;          had been read from the file: rad_cf_nir[203, 52].
   ;
   ;      -   Similarly, the data buffer containing the Brf values for the
   ;          BA camera in the Green spectral band is accessible as
   ;          brf_ba_green = *brf_ptr[6, 1].
   ;
   ;      -   And the data buffer containing the RDQI values for the AN
   ;          camera in the red spectral band is accessible as
   ;          rdqi_an_red = *rdqi_ptr[5, 2].
   ;
   ;  *   NOTE 2: The 36 scale factors are DOUBLE values, one per camera
   ;      and spectral band.
   ;
   ;  *   NOTE 3: The 36 conversion factors available in the L1B2 files
   ;      are provided on a grid of 32 samples by 8 lines for each BLOCK,
   ;      i.e., at a sampling distance of 17.6 km. Instead, the conversion
   ;      factors contained in the arrays convf_ptr provide values for
   ;      each individual pixel, i.e., at whatever spatial resolution this
   ;      particular data channel is available. The fill values on the
   ;      extreme edges of the BLOCK are -444.0, as in the original data.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'GM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> misr_block = 110
   ;      IDL> rc = heap_l1b2_block(misr_mode, misr_path, misr_orbit, $
   ;         misr_block, misr_ptr, radrd_ptr, rad_ptr, brf_ptr, $
   ;         rdqi_ptr, scalf_ptr, convf_ptr, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;         L1B2LM_FOLDER = l1b2lm_folder, L1B2LM_VERSION = l1b2lm_version, $
   ;         MISR_SITE = misr_site, VERBOSE = verbose, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> HELP, radrd_ptr
   ;      RADRD_PTR       POINTER   = Array[9, 4]
   ;      IDL> rad_cf_nir = *radrd_ptr[1, 3]
   ;      IDL> PRINT, 'rad_cf_nir[200, 120] = ' + $
   ;         strstr(rad_cf_nir[200, 120])
   ;      rad_cf_nir[200, 120] = 11652
   ;
   ;  REFERENCES:
   ;
   ;  *   Mike Bull, Jason Matthews, Duncan McDonald, Alexander Menzies,
   ;      Catherine Moroney, Kevin Mueller, Susan Paradise, Mike
   ;      Smyth (2011) _MISR Data Products Specifications_, JPL D-13963,
   ;      REVISION S, Section 6.5.6, p. 72–73, Jet Propulsion Laboratory,
   ;      California Institute of Technology, Pasadena, CA, USA.
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
   ;  *   2019–02–23: Version 0.9 — Initial release.
   ;
   ;  *   2019–02–25: Version 1.0 — Initial public release.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.01 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–04–17: Version 2.02 — Update the code to retrieve the scale
   ;      factors used to convert the unsigned 14-bit integer data into
   ;      radiance measurements, in units of W m^( − 2) sr^( − 1)
   ;      μm^( − 1), and to place the floating point radiance measurements
   ;      on the heap too.
   ;
   ;  *   2019–04–23: Version 2.03 — Update the code to also provide
   ;      pointers to the conversion factors needed to convert the
   ;      radiances into the bidirectional reflectance factors.
   ;
   ;  *   2019–05–04: Version 2.04 — Update the code to report the
   ;      specific error message of MTK routines.
   ;
   ;  *   2019–06–12: Version 2.05 — Update the documentation.
   ;
   ;  *   2019–08–10: Version 2.06 — Update this function to include a
   ;      full set of input positional and keyword parameters and call the
   ;      functions find_l1b2gm_files.pro and find_l1b2lm_files.pro to
   ;      locate the files: This function now works for either GM or LM
   ;      data.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–09–17: Version 2.1.1 — Add the keywords TEST_ID, FIRST_LINE
   ;      and LAST_LINE to load on the heap L1B2 data buffers with
   ;      additional missing data inserted for the purpose of testing.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
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
   IF (~KEYWORD_SET(test_id)) THEN BEGIN
      test_id = ''
      IF (test_id EQ '') THEN BEGIN
         first_line = MAKE_ARRAY(9, 4, /INTEGER, VALUE = -1)
         last_line = MAKE_ARRAY(9, 4, /INTEGER, VALUE = -1)
      ENDIF
   ENDIF
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
      n_reqs = 11
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_mode, misr_path, ' + $
            'misr_orbit, misr_block, misr_ptr, radrd_ptr, rad_ptr, ' + $
            'brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_mode' is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
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
               RETURN, error_code
            END
            (res EQ -1): BEGIN
               error_code = 134
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            END
            ELSE: BEGIN
               error_code = 136
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Unexpected return code ' + strstr(res) + $
                  ' from is_frompath.pro.'
               RETURN, error_code
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
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called upon to retrieve Local Mode data but the Site name is not
   ;  provided:
      IF ((misr_mode EQ 'LM') AND (~KEYWORD_SET(misr_site))) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Local Mode data are requested but the keyword parameter ' + $
            'MISR_SITE is not specified.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional input
   ;  keyword parameter 'test_id' is set but not as a STRING:
      IF (KEYWORD_SET(test_id) AND (is_string(test_id) NE 1)) THEN BEGIN
         error_code = 160
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
         error_code = 170
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
         error_code = 180
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
   maxgmlines = misr_specs.GMChannelLines

   ;  Return to the calling routine with an error message if the values of the
   ;  optional input keyword parameters 'first_line' and 'last_line' are
   ;  inconsistent:
   IF (debug AND (test_id NE '')) THEN BEGIN
      FOR cam = 0, n_cams - 1 DO BEGIN
         FOR bnd = 0, n_bnds - 1 DO BEGIN
            IF (misr_mode EQ 'GM') THEN BEGIN
               IF ((first_line[cam, bnd] LT 0) OR $
                  (first_line[cam, bnd] GT maxgmlines[cam, bnd])) THEN $
                  first_line[cam, bnd] = -1
               IF ((last_line[cam, bnd] LT 0) OR $
                  (last_line[cam, bnd] GT maxgmlines[cam, bnd])) THEN $
                  last_line[cam, bnd] = -1
            ENDIF ELSE BEGIN
               IF ((first_line[cam, bnd] LT 0) OR $
                  (first_line[cam, bnd] GT 512)) THEN $
                  first_line[cam, bnd] = -1
               IF ((last_line[cam, bnd] LT 0) OR $
                  (last_line[cam, bnd] GT 512)) THEN $
                  last_line[cam, bnd] = -1
            ENDELSE
            IF (first_line[cam, bnd] GT last_line[cam, bnd]) THEN BEGIN
               error_code = 190
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': At least one of the couples ' + $
                  '(first_line, last_line) is inconsistent: Check ' + $
                  'camera ' + strstr(cam) + ' and band ' + strstr(bnd) + '.'
               RETURN, error_code
            ENDIF
         ENDFOR
      ENDFOR
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
   ;  explicitly, and retrieve the names of the appropriate MISR L1B2 files:
   CASE misr_mode OF
      'GM': BEGIN
         IF (~KEYWORD_SET(l1b2gm_version)) THEN l1b2gm_version = versions[2]
         misr_version = l1b2gm_version
         rc = find_l1b2gm_files(misr_path, misr_orbit, l1b2gm_files, $
            L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (debug AND (rc NE 0)) THEN BEGIN
            error_code = 300
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
         l1b2_files = l1b2gm_files
      END
      'LM': BEGIN
         IF (~KEYWORD_SET(l1b2lm_version)) THEN l1b2lm_version = versions[3]
         misr_version = l1b2lm_version
         rc = find_l1b2lm_files(misr_site, misr_path, misr_orbit, $
            l1b2lm_files, L1B2LM_FOLDER = l1b2lm_folder, $
            L1B2LM_VERSION = l1b2lm_version, VERBOSE = verbose, $
            DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (debug AND (rc NE 0)) THEN BEGIN
            error_code = 310
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
         l1b2_files = l1b2lm_files
      END
   ENDCASE

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 510
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 520
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the region of interest:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_SETREGION_BY_PATH_BLOCKRANGE: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   ;  Define the output arrays of pointers to the L1B2 data buffers to be
   ;  placed on the heap:
   misr_ptr = PTR_NEW([misr_mode, misr_path_str, misr_orbit_str, + $
      misr_block_str, misr_version])
   radrd_ptr = PTRARR(9, 4)
   rad_ptr = PTRARR(9, 4)
   brf_ptr = PTRARR(9, 4)
   rdqi_ptr = PTRARR(9, 4)
   scalf_ptr = PTRARR(9, 4)
   convf_ptr = PTRARR(9, 4)

   ;  Loop over the camera files:
   FOR cam = 0, n_cams - 1 DO BEGIN

   ;  Loop over the spectral bands:
      FOR bnd = 0, n_bnds - 1 DO BEGIN

   ;  Read the scaled radiance data (with the RDQI attached) for the current
   ;  camera and band, and add the UINT data array to the heap:
         grid = misr_bnds[bnd] + 'Band'
         field = misr_bnds[bnd] + ' Radiance/RDQI'
         status = MTK_READDATA(l1b2_files[cam], grid, field, region, $
            radrd_databuf, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 610
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_READDATA: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF

   ;  Insert missing values in the current data buffer if required:
         IF (test_id NE '') THEN BEGIN
            IF ((first_line[cam, bnd] GE 0) AND (last_line[cam, bnd] GE 0)) $
               THEN BEGIN
               FOR line = first_line[cam, bnd], last_line[cam, bnd] DO BEGIN
                  idx = WHERE((radrd_databuf[*, line] LT 65511), n_meas)
                  IF (n_meas GT 0) THEN radrd_databuf[idx, line] = 65523U
               ENDFOR
            ENDIF
         ENDIF

   ;  Load the data on the heap:
         radrd_ptr[cam, bnd] = PTR_NEW(radrd_databuf)

   ;  Read the radiance data (without the RDQI attached) for the current
   ;  camera and band, and add the floating point data array to the heap:
         grid = misr_bnds[bnd] + 'Band'
         field = misr_bnds[bnd] + ' Radiance'
         status = MTK_READDATA(l1b2_files[cam], grid, field, region, $
            rad_databuf, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 620
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_READDATA: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF

   ;  Insert missing values in the current data buffer if required:
         IF (test_id NE '') THEN BEGIN
            IF ((first_line[cam, bnd] GE 0) AND (last_line[cam, bnd] GE 0)) $
               THEN BEGIN
               FOR line = first_line[cam, bnd], last_line[cam, bnd] DO BEGIN
                  idx = WHERE((rad_databuf[*, line] GT 0.0), n_meas)
                  IF (n_meas GT 0) THEN rad_databuf[idx, line] = 0.0
               ENDFOR
            ENDIF
         ENDIF

   ;  Load the data on the heap:
         rad_ptr[cam, bnd] = PTR_NEW(rad_databuf)

   ;  Read the Brf data for the current camera and band, and add the FLOAT
   ;  data array to the heap:
         grid = misr_bnds[bnd] + 'Band'
         field = misr_bnds[bnd] + ' Brf'
         status = MTK_READDATA(l1b2_files[cam], grid, field, region, $
            brf_databuf, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 630
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_READDATA: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF

   ;  Insert missing values in the current data buffer if required:
         IF (test_id NE '') THEN BEGIN
            IF ((first_line[cam, bnd] GE 0) AND (last_line[cam, bnd] GE 0)) $
               THEN BEGIN
               FOR line = first_line[cam, bnd], last_line[cam, bnd] DO BEGIN
                  idx = WHERE((brf_databuf[*, line] GT 0.0), n_meas)
                  IF (n_meas GT 0) THEN brf_databuf[idx, line] = 0.0
               ENDFOR
            ENDIF
         ENDIF

   ;  Load the data on the heap:
         brf_ptr[cam, bnd] = PTR_NEW(brf_databuf)

   ;  Read the RDQI data for the current camera and band, and add the BYTE
   ;  data array to the heap:
         grid = misr_bnds[bnd] + 'Band'
         field = misr_bnds[bnd] + ' RDQI'
         status = MTK_READDATA(l1b2_files[cam], grid, field, region, $
            rdq_databuf, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 640
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_READDATA: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF

   ;  Insert missing values in the current data buffer if required:
         IF (test_id NE '') THEN BEGIN
            IF ((first_line[cam, bnd] GE 0) AND (last_line[cam, bnd] GE 0)) $
               THEN BEGIN
               FOR line = first_line[cam, bnd], last_line[cam, bnd] DO BEGIN
                  idx = WHERE((rdq_databuf[*, line] LT 3B), n_meas)
                  IF (n_meas GT 0) THEN rdq_databuf[idx] = 3B
               ENDFOR
            ENDIF
         ENDIF

   ;  Load the data on the heap:
         rdqi_ptr[cam, bnd] = PTR_NEW(rdq_databuf)

   ;  Read the scale factor used to convert the unsigned 14-bit integer into
   ;  a radiance measurement, in units of W m−2 sr−1 μm−1:
         grid = misr_bnds[bnd] + 'Band'
         field = 'Scale factor'
         scale_factor = 0.0D
         status = MTK_GRIDATTR_GET(l1b2_files[cam], grid, field, scale_factor)
         IF (debug AND (scale_factor EQ 0.0)) THEN BEGIN
            error_code = 650
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_GRIDATTR_GET: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF
         scalf_ptr[cam, bnd] = PTR_NEW(DOUBLE(scale_factor[0]))

   ;  Read the conversion factors, provided as a low spatial resolution (17.6
   ;  km) databuffer:
         grid = 'BRF Conversion Factors'
         field = misr_bnds[bnd] + 'ConversionFactor'
         status = MTK_READDATA(l1b2_files[cam], grid, field, region, $
            conv_databuf, mapinfo)
         IF (debug AND (status NE 0)) THEN BEGIN
            error_code = 660
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error message from MTK_READDATA: ' + $
               MTK_ERROR_MESSAGE(status)
            RETURN, error_code
         ENDIF

   ;  Upscale those values by duplication to match the L1B2 spatial resolution
   ;  of this data channel:
         sz_b = SIZE(brf_databuf, /STRUCTURE)
         sz_c = SIZE(conv_databuf, /STRUCTURE)
         factor = sz_b.dimensions[0] / sz_c.dimensions[0]
         convf = MAKE_ARRAY(sz_c.dimensions[0] * factor, $
            sz_c.dimensions[1] * factor, TYPE = sz_c.type)
         FOR i = 0, sz_c.dimensions[0] - 1 DO BEGIN
            FOR j = 0, sz_c.dimensions[1] - 1 DO BEGIN
               convf[i * factor:((i + 1) * factor) - 1, $
                  j * factor:((j + 1) * factor) - 1] = conv_databuf[i, j]
            ENDFOR
         ENDFOR
         convf_ptr[cam, bnd] = PTR_NEW(convf)

      ENDFOR
   ENDFOR

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
