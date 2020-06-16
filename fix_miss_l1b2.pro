FUNCTION fix_miss_l1b2, $
   misr_ptr, $
   radrd_ptr, $
   rad_ptr, $
   brf_ptr, $
   rdqi_ptr, $
   scalf_ptr, $
   convf_ptr, $
   lwc_mask_ptr, $
   fixed_misr_ptr, $
   fixed_radrd_ptr, $
   fixed_rad_ptr, $
   fixed_brf_ptr, $
   fixed_rdqi_ptr, $
   n_miss_lnd_ptr, $
   idx_miss_lnd_ptr, $
   n_miss_wat_ptr, $
   idx_miss_wat_ptr, $
   n_miss_cld_ptr, $
   idx_miss_cld_ptr, $
   best_fits_ptr, $
   N_MASKS = n_masks, $
   N_ATTEMPTS = n_attempts, $
   MAIN_LOG_IT = main_log_it, $
   MAIN_LOG_UNIT = main_log_unit, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function replaces the missing radiance values found in
   ;  the 36 L1B2 databuffers of the input MISR BLOCK by optimal esimates.
   ;
   ;  ALGORITHM: This function replaces the missing radiance values
   ;  (scaled radiance value with RDQI attached of 65523U) identified by
   ;  the function pre_fix_l1b2.pro by estimates based on the best fits
   ;  between the target data channel and the 35 other source data
   ;  channels and resets their RDQI to 1B. The input keyword parameter
   ;  N_ATTEMPTS controls how many attempts are allowed to replace the
   ;  missing values, using successive best fits in decreasing order of
   ;  correlation coefficient between the target and the source
   ;  databuffers.
   ;
   ;  SYNTAX: rc = fix_miss_l1b2(misr_ptr, radrd_ptr, rad_ptr, $
   ;  brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, lwc_mask_ptr, $
   ;  fixed_misr_ptr, fixed_radrd_ptr, fixed_rad_ptr, $
   ;  fixed_brf_ptr, fixed_rdqi_ptr, n_miss_lnd_ptr, idx_miss_lnd_ptr, $
   ;  n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr, $
   ;  idx_miss_cld_ptr, best_fits_ptr, N_MASKS = n_masks, $
   ;  N_ATTEMPTS = n_attempts, $
   ;  MAIN_LOG_IT = main_log_it, MAIN_LOG_UNIT = main_log_unit, $
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
   ;      (DF to DA).
   ;
   ;  *   rad_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the FLOAT L1B2 radiance
   ;      values (hence without the RDQI attached), in the native order
   ;      (DF to DA).
   ;
   ;  *   brf_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the FLOAT L1B2 BRF values,
   ;      in the native order (DF to DA).
   ;
   ;  *   rdqi_ptr {POINTER array} [I]: The array of 36 pointers to the
   ;      original MISR data buffers containing the BYTE L1B2 RDQI values,
   ;      in the native order (DF to DA).
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
   ;  *   lwc_mask_ptr {POINTER array} [I]: The array of 36 (9 cameras by
   ;      4 spectral bands) pointers to the BYTE masks containing the
   ;      information on the spatial distribution of geophysical media to
   ;      consider, as defined by n_masks.
   ;
   ;  *   fixed_misr_ptr {POINTER} [I/O]: The pointer to a STRING array
   ;      containing metadata on the MISR MODE, PATH, ORBIT and BLOCK of
   ;      the next 4 pointer arrays.
   ;
   ;  *   fixed_radrd_ptr {POINTER array} [I/O]: The array of 36 pointers
   ;      to the updated MISR data buffers containing the UINT L1B2 scaled
   ;      radiance values (with the RDQI attached), in the native order
   ;      (DF to DA).
   ;
   ;  *   fixed_rad_ptr {POINTER array} [I/O]: The array of 36 pointers to
   ;      the updated MISR data buffers containing the FLOAT L1B2 radiance
   ;      values (hence without the RDQI attached), in the native order
   ;      (DF to DA).
   ;
   ;  *   fixed_brf_ptr {POINTER array} [I/O]: The array of 36 pointers to
   ;      the updated MISR data buffers containing the FLOAT L1B2 BRF
   ;      values, in the native order (DF to DA).
   ;
   ;  *   fixed_rdqi_ptr {POINTER array} [I/O]: The array of 36 pointers
   ;      to the updated MISR data buffers containing the BYTE L1B2 RDQI
   ;      values, in the native order (DF to DA).
   ;
   ;  *   n_miss_lnd_ptr {POINTER array} [I/O]: The array of pointers to
   ;      the number of missing pixel values over land masses in each of
   ;      the 36 data channels of the input databuffer.
   ;
   ;  *   idx_miss_lnd_ptr {POINTER array} [I/O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      missing pixel values over land masses in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_miss_wat_ptr {POINTER array} [I/O]: The array of pointers to
   ;      the number of missing pixel values over water bodies in each of
   ;      the 36 data channels of the input databuffer.
   ;
   ;  *   idx_miss_wat_ptr {POINTER array} [I/O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      missing pixel values over water bodies in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_miss_cld_ptr {POINTER array} [I/O]: The array of pointers to
   ;      the number of missing pixel values over cloud fields in each of
   ;      the 36 data channels of the input databuffer.
   ;
   ;  *   idx_miss_cld_ptr {POINTER array} [I/O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      missing pixel values over cloud fields in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   best_fits_ptr {POINTER array} [I]: The array of pointers to the
   ;      output structures containing the statistical information on the
   ;      correlation between the targets and the source data channels.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   N_MASKS = n_masks {INT} [I] (Default value: 3): The number of
   ;      target types that need to be discriminated by the masks: 1 to
   ;      generate a single mask for all geophysical target types, 2 to
   ;      generate masks separately for land masses and water bodies, or 3
   ;      to generate masks separately for clear land masses, clear water
   ;      bodies and cloud fields.
   ;
   ;  *   N_ATTEMPTS = n_attempts {INT} [I] (Default value: 1): Flag to
   ;      indicate the maximum number of ‘best’ linear fit equations can
   ;      be considered when trying to replace bad (missing) or optionally
   ;      missing L1B2 values.
   ;
   ;  *   MAIN_LOG_IT = main_log_it {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) writing intermediary results to a
   ;      pre-existing log file.
   ;
   ;  *   MAIN_LOG_UNIT = main_log_unit {IDL Logical Unit Number} [I] (Default: None):
   ;      The IDL Logical Unit Number of the main log file, which must be
   ;      opened for writing prior to calling this function.
   ;
   ;  *   VERBOSE = verbose {INT} [I] (Default value: 0): Flag to enable
   ;      (> 0) or skip (0) outputting messages on the console:
   ;
   ;      -   If verbose > 0, messages inform the user about progress in
   ;          the execution of time-consuming routines, or the location of
   ;          output files (e.g., log, map, plot, etc.);
   ;
   ;      -   If verbose > 1, messages record entering and exiting the
   ;          routine; and
   ;
   ;      -   If verbose > 2, messages provide additional information
   ;          about intermediary results.
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
   ;      provided in the call. The output positional parameters
   ;      fixed_misr_ptr, fixed_radrd_ptr, fixed_rad_ptr, fixed_brf_ptr,
   ;      fixed_rdqi_ptr, n_miss_lnd_ptr, idx_miss_lnd_ptr,
   ;      n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr,
   ;      idx_miss_cld_ptr contain the results generated by this function.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters fixed_misr_ptr,
   ;      fixed_radrd_ptr, fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr,
   ;      n_miss_lnd_ptr, idx_miss_lnd_ptr, n_miss_wat_ptr,
   ;      idx_miss_wat_ptr, n_miss_cld_ptr, idx_miss_cld_ptr may be
   ;      incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: At least one of the following input positional
   ;      parameters is not a pointer: misr_ptr, radrd_ptr, rad_ptr,
   ;      brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr.
   ;
   ;  *   Error 120: At least one of the following input positional
   ;      parameters is not a pointer: fixed_misr_ptr, fixed_radrd_ptr,
   ;      fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr.
   ;
   ;  *   Error 130: At least one of the following input positional
   ;      parameters is not a pointer: n_miss_lnd_ptr, idx_miss_lnd_ptr,
   ;      n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr,
   ;      idx_miss_cld_ptr, best_fits_ptr.
   ;
   ;  *   Error 200: Unrecognized camera name in retrieving best fits for
   ;      missing land pixels.
   ;
   ;  *   Error 202: Unrecognized spectral band name in retrieving best
   ;      fits for missing land pixels.
   ;
   ;  *   Error 210: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 211: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 212: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 213: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 214: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 215: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 216: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 217: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 218: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 219: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 220: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 230: Unrecognized camera name in retrieving best fits for
   ;      missing water pixels.
   ;
   ;  *   Error 232: Unrecognized spectral band name in retrieving best
   ;      fits for missing water pixels.
   ;
   ;  *   Error 240: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 241: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 242: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 243: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 244: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 245: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 246: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 247: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 248: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 249: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 250: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 260: Unrecognized camera name in retrieving best fits for
   ;      missing cloud pixels.
   ;
   ;  *   Error 262: Unrecognized spectral band name in retrieving best
   ;      fits for missing cloud pixels.
   ;
   ;  *   Error 270: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 271: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 272: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 273: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 274: An exception condition occurred in lr2hr.
   ;
   ;  *   Error 275: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 276: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 277: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 278: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 279: An exception condition occurred in hr2lr.
   ;
   ;  *   Error 280: An exception condition occurred in lr2hr.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_pointer.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: In the section describing the positional parameters
   ;      above, the variables fixed_misr_ptr, fixed_radrd_ptr,
   ;      fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr, n_miss_lnd_ptr,
   ;      idx_miss_lnd_ptr, n_miss_wat_ptr, idx_miss_wat_ptr,
   ;      n_miss_cld_ptr and idx_miss_cld_ptr are described as both input
   ;      and output because they must be initialized with the original
   ;      values prior to calling this function, and may be subsequently
   ;      updated as needed by this function.
   ;
   ;  EXAMPLES:
   ;
   ;      [See the outcome(s) generated by fix_l1b2.pro]
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
   ;  *   2020–05–02: Version 2.1.6 — Update the documentation.
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

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential keyword parameters:
   IF (~KEYWORD_SET(n_masks)) THEN BEGIN
      n_masks = 3
   ENDIF ELSE BEGIN
      IF (is_numeric(n_masks)) THEN BEGIN
         IF ((n_masks LT 1) OR (n_masks GT 3)) THEN n_masks = 3
      ENDIF ELSE BEGIN
         n_masks = 3
      ENDELSE
   ENDELSE
   IF (KEYWORD_SET(main_log_it)) THEN main_log_it = 1 ELSE main_log_it = 0
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
      n_reqs = 20
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_ptr, radrd_ptr, rad_ptr, ' + $
            'brf_ptr, rdqi_ptr, scalf_ptr, convf_ptr, lwc_mask_ptr, ' + $
            'fixed_misr_ptr, fixed_radrd_ptr, fixed_rad_ptr, ' + $
            'fixed_brf_ptr, fixed_rdqi_ptr, n_miss_lnd_ptr, ' + $
            'idx_miss_lnd_ptr, n_miss_wat_ptr, idx_miss_wat_ptr, ' + $
            'n_miss_cld_ptr, idx_miss_cld_ptr, best_fits_ptr.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if anyone of the
   ;  input positional parameters 'misr_ptr', 'radrd_ptr', 'rad_ptr',
   ;  'rdqi_ptr', or 'lwc_mask_ptr' is not a pointer:
      res1 = is_pointer(misr_ptr)
      res2 = is_pointer(radrd_ptr)
      res3 = is_pointer(rad_ptr)
      res4 = is_pointer(brf_ptr)
      res5 = is_pointer(rdqi_ptr)
      res6 = is_pointer(scalf_ptr)
      res7 = is_pointer(convf_ptr)
      IF ((res1 NE 1) OR (res2 NE 1) OR (res3 NE 1) OR $
         (res4 NE 1) OR (res5 NE 1) OR (res6 NE 1) OR (res7 NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': At least one of the following input positional parameters ' + $
            'is not a pointer: misr_ptr, radrd_ptr, rad_ptr, brf_ptr, ' + $
            'rdqi_ptr, scalf_ptr, convf_ptr.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if anyone of the
   ;  input positional parameters 'fixed_misr_ptr', 'fixed_radrd_ptr',
   ;  'fixed_rad_ptr', 'fixed_brf_ptr' or 'fixed_rdqi_ptr' is not a pointer:
      res1 = is_pointer(fixed_misr_ptr)
      res2 = is_pointer(fixed_radrd_ptr)
      res3 = is_pointer(fixed_rad_ptr)
      res4 = is_pointer(fixed_brf_ptr)
      res5 = is_pointer(fixed_rdqi_ptr)
      IF ((res1 NE 1) OR (res2 NE 1) OR (res3 NE 1) OR $
         (res4 NE 1) OR (res5 NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': At least one of the following input positional parameters ' + $
            'is not a pointer: fixed_misr_ptr, fixed_radrd_ptr, ' + $
            'fixed_rad_ptr, fixed_brf_ptr, fixed_rdqi_ptr.'
            RETURN, error_code
         ENDIF

   ;  Return to the calling routine with an error message if anyone of the
   ;  input positional parameters 'n_miss_lnd_ptr', 'idx_miss_lnd_ptr',
   ;  'n_miss_wat_ptr', 'idx_miss_wat_ptr', 'n_miss_cld_ptr',
   ;  'idx_miss_cld_ptr', or 'best_fits_ptr' is not a pointer:
      res1 = is_pointer(n_miss_lnd_ptr)
      res2 = is_pointer(idx_miss_lnd_ptr)
      res3 = is_pointer(n_miss_wat_ptr)
      res4 = is_pointer(idx_miss_wat_ptr)
      res5 = is_pointer(n_miss_cld_ptr)
      res6 = is_pointer(idx_miss_cld_ptr)
      res7 = is_pointer(best_fits_ptr)
      IF ((res1 NE 1) OR (res2 NE 1) OR (res3 NE 1) OR $
         (res4 NE 1) OR (res5 NE 1) OR (res6 NE 1) OR (res7 NE 1)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': At least one of the following input positional parameters ' + $
            'is not a pointer: n_miss_lnd_ptr, idx_miss_lnd_ptr, ' + $
            'n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr, ' + $
            'idx_miss_cld_ptr, best_fits_ptr.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Unpack the MISR metadata information:
   temp = *misr_ptr
   misr_mode = temp[0]
   misr_path_str = temp[1]
   misr_orbit_str = temp[2]
   misr_block_str = temp[3]
   misr_version = temp[4]

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   misr_cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames

   fmt1 = '(A30, A)'

   ;  Loop over the target cameras and spectral bands by number, in the
   ;  natural MISR order:
   FOR cam = 0, n_cams - 1 DO BEGIN

      FOR bnd = 0, n_bnds - 1 DO BEGIN

   ;  Generate the corresponding target data channel name:
         cam_bnd = misr_cams[cam] + '_' + misr_bnds[bnd]

   ;  Access the L1B2 data for the current target data channel:
         tgt_rad = *rad_ptr[cam, bnd]
         tgt_radrd = *radrd_ptr[cam, bnd]
         tgt_brf = *brf_ptr[cam, bnd]
         tgt_rdqi = *rdqi_ptr[cam, bnd]

   ;  Set the scaling and conversion factors (a DOUBLE value and a FLOAT array,
   ;  respectively) for this data channel:
         scalf = *scalf_ptr[cam, bnd]
         convf = *convf_ptr[cam, bnd]

   ;  Retrieve the number of missing values and their locations in the current
   ;  data channel, depending on the required number of masks:
         n_miss_lnd = *n_miss_lnd_ptr[cam, bnd]
         idx_miss_lnd = *idx_miss_lnd_ptr[cam, bnd]
         n_miss = n_miss_lnd
         IF (n_masks GT 1) THEN BEGIN
            n_miss_wat = *n_miss_wat_ptr[cam, bnd]
            idx_miss_wat = *idx_miss_wat_ptr[cam, bnd]
            n_miss = n_miss + n_miss_wat
         ENDIF
         IF (n_masks GT 2) THEN BEGIN
            n_miss_cld = *n_miss_cld_ptr[cam, bnd]
            idx_miss_cld = *idx_miss_cld_ptr[cam, bnd]
            n_miss = n_miss + n_miss_cld
         ENDIF

   ;  If no missing values need to be replaced, proceed to the next camera and
   ;  spectral band:
         IF (n_miss EQ 0) THEN BEGIN
            IF (verbose GT 0) THEN BEGIN
               PRINT, '   ***   No missing values found in camera ' + $
                  misr_cams[cam] + ' and band ' + misr_bnds[bnd] + '.'
            ENDIF
            CONTINUE
         ENDIF ELSE BEGIN
            IF (verbose GT 0) THEN BEGIN
               PRINT, $
               '   ***   Attempting to replace ' + strstr(n_miss) + $
               ' missing values in camera ' + misr_cams[cam] + $
               ' and band ' + misr_bnds[bnd] + '.'
               IF (main_log_it) THEN PRINTF, main_log_unit, strrepeat('-', 40)
            ENDIF
         ENDELSE

   ;  Record the camera and spectral band names of the current target camera
   ;  data channel, set its spatial resolution, and set the target masks,
   ;  which are natively at the reduced spatial resolution:
         target_camera = misr_cams[cam]
         target_band = misr_bnds[bnd]
         target_resol = 275
         IF (misr_mode EQ 'GM') THEN BEGIN
            IF ((misr_cams[cam] NE 'AN') AND $
               (misr_bnds[bnd] NE 'Red')) THEN $
               target_resol = 1100
         ENDIF
         target_mask = *lwc_mask_ptr[cam, bnd]

   ;  Define the arrays that will contain the first 'n_attempts' best results
   ;  to replace values in the current target data channel over land masses:
         bst_src_cam_nam_lnd = STRARR(n_attempts)
         bst_src_cam_num_lnd = INTARR(n_attempts)
         bst_src_bnd_nam_lnd = STRARR(n_attempts)
         bst_src_bnd_num_lnd = INTARR(n_attempts)
         bst_src_npts_lnd = LONARR(n_attempts)
         bst_src_rmsd_lnd = FLTARR(n_attempts)
         bst_src_corr_lnd = FLTARR(n_attempts)
         bst_src_coefa_lnd = FLTARR(n_attempts)
         bst_src_coefb_lnd = FLTARR(n_attempts)
         bst_src_chi_lnd = FLTARR(n_attempts)
         bst_src_resol_lnd = INTARR(n_attempts)

   ;  Define the arrays that will contain the first 'n_attempts' best results
   ;  to replace values in the current target data channel over water bodies:
         IF (n_masks GT 1) THEN BEGIN
            bst_src_cam_nam_wat = STRARR(n_attempts)
            bst_src_cam_num_wat = INTARR(n_attempts)
            bst_src_bnd_nam_wat = STRARR(n_attempts)
            bst_src_bnd_num_wat = INTARR(n_attempts)
            bst_src_npts_wat = LONARR(n_attempts)
            bst_src_rmsd_wat = FLTARR(n_attempts)
            bst_src_corr_wat = FLTARR(n_attempts)
            bst_src_coefa_wat = FLTARR(n_attempts)
            bst_src_coefb_wat = FLTARR(n_attempts)
            bst_src_chi_wat = FLTARR(n_attempts)
            bst_src_resol_wat = INTARR(n_attempts)
         ENDIF

   ;  Define the arrays that will contain the first 'n_attempts' best results
   ;  to replace values in the current target data channel over cloud fields:
         IF (n_masks GT 2) THEN BEGIN
            bst_src_cam_nam_cld = STRARR(n_attempts)
            bst_src_cam_num_cld = INTARR(n_attempts)
            bst_src_bnd_nam_cld = STRARR(n_attempts)
            bst_src_bnd_num_cld = INTARR(n_attempts)
            bst_src_npts_cld = LONARR(n_attempts)
            bst_src_rmsd_cld = FLTARR(n_attempts)
            bst_src_corr_cld = FLTARR(n_attempts)
            bst_src_coefa_cld = FLTARR(n_attempts)
            bst_src_coefb_cld = FLTARR(n_attempts)
            bst_src_chi_cld = FLTARR(n_attempts)
            bst_src_resol_cld = INTARR(n_attempts)
         ENDIF

   ;  Loop over the attempts to find a suitable source data channel:
         attempt = 0
         WHILE (attempt LT n_attempts) DO BEGIN
            IF (main_log_it) THEN BEGIN
               PRINTF, main_log_unit
               PRINTF, main_log_unit, 'Replacing missing values in: ', cam_bnd, $
                  FORMAT = fmt1
               PRINTF, main_log_unit, 'Attempt #: ', strstr(attempt), $
                  FORMAT = fmt1
            ENDIF

   ;  ===============================================================
   ;  Process missing values over land masses, if any:
            n_miss_lnd = *n_miss_lnd_ptr[cam, bnd]
            IF (n_miss_lnd GT 0) THEN BEGIN

   ;  Retrieve the best CAMERA name and number to replace missing values
   ;  over land masses by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestLandCameras
               bst_src_cam_nam_lnd[attempt] = temp2[attempt]
               bst_src_cam_num_lnd[attempt] = WHERE(misr_cams EQ $
                  bst_src_cam_nam_lnd[attempt], cnt)
               IF (cnt EQ 1) THEN BEGIN
                  bst_src_cam_num_lnd[attempt] = $
                     FIX(bst_src_cam_num_lnd[attempt])
               ENDIF ELSE BEGIN
                  error_code = 200
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': Unrecognized camera name in ' + $
                     'retrieving best fits for missing land pixels.'
                  RETURN, error_code
               ENDELSE

   ;  Retrieve the best SPECTRAL BAND name and number to replace missing values
   ;  over land masses by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestLandBands
               bst_src_bnd_nam_lnd[attempt] = temp2[attempt]
               bst_src_bnd_num_lnd[attempt] = WHERE(misr_bnds EQ $
                  bst_src_bnd_nam_lnd[attempt], cnt)
               IF (cnt EQ 1) THEN BEGIN
                  bst_src_bnd_num_lnd[attempt] = $
                     FIX(bst_src_bnd_num_lnd[attempt])
               ENDIF ELSE BEGIN
                  error_code = 202
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': Unrecognized spectral band name in ' + $
                     'retrieving best fits for missing land pixels.'
                  RETURN, error_code
               ENDELSE

   ;  Retrieve the corresponding statistics to replace missing values
   ;  over land masses by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestLandNpts
               bst_src_npts_lnd[attempt] = temp2[attempt]

               temp2 = temp1.BestLandRMSDs
               bst_src_rmsd_lnd[attempt] = temp2[attempt]

               temp2 = temp1.BestLandCors
               bst_src_corr_lnd[attempt] = temp2[attempt]

               temp2 = temp1.BestLandAs
               bst_src_coefa_lnd[attempt] = temp2[attempt]

               temp2 = temp1.BestLandBs
               bst_src_coefb_lnd[attempt] = temp2[attempt]

               temp2 = temp1.BestLandChisqs
               bst_src_chi_lnd[attempt] = temp2[attempt]

   ;  Set the land/water/cloud mask for the current best source camera and
   ;  band to update the current target channel (an array with dimensions
   ;  equal to the corresponding source radiance array):
               source_mask = *lwc_mask_ptr[bst_src_cam_num_lnd[attempt], $
                  bst_src_bnd_num_lnd[attempt]]

   ;  Report on the plan to replace missing values in the current target:
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit
                  n_miss_lnd = *n_miss_lnd_ptr[cam, bnd]
                  PRINTF, main_log_unit, '# missing land values: ', $
                     strstr(n_miss_lnd), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best source: ', $
                     bst_src_cam_nam_lnd[attempt] + '/' + $
                     bst_src_bnd_nam_lnd[attempt], FORMAT = fmt1
                  PRINTF, main_log_unit, '# common tgt/src data points: ', $
                     strstr(bst_src_npts_lnd[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best Chi^2: ', $
                     strstr(bst_src_chi_lnd[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best RMSD: ', $
                     strstr(bst_src_rmsd_lnd[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best PCC: ', $
                     strstr(bst_src_corr_lnd[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best fit equation: ', $
                     'target = ' + strstr(bst_src_coefa_lnd[attempt]) + $
                     ' + ' + strstr(bst_src_coefb_lnd[attempt]) + $
                     ' * source', FORMAT = fmt1
                  PRINTF, main_log_unit
               ENDIF

   ;  Access the L1B2 data for the current best source data channel:
               src_rad = *rad_ptr[bst_src_cam_num_lnd[attempt], $
                  bst_src_bnd_num_lnd[attempt]]
               src_radrd = *radrd_ptr[bst_src_cam_num_lnd[attempt], $
                  bst_src_bnd_num_lnd[attempt]]
               src_brf = *brf_ptr[bst_src_cam_num_lnd[attempt], $
                  bst_src_bnd_num_lnd[attempt]]
               src_rdqi = *rdqi_ptr[bst_src_cam_num_lnd[attempt], $
                  bst_src_bnd_num_lnd[attempt]]

   ;  Set the resolution of the current best source data channel:
               bst_src_resol_lnd[attempt] = 275
               IF (misr_mode EQ 'GM') THEN BEGIN
                  IF ((bst_src_cam_nam_lnd[attempt] NE 'AN') AND $
                     (bst_src_bnd_nam_lnd[attempt] NE 'Red')) THEN $
                     bst_src_resol_lnd[attempt] = 1100
               ENDIF

   ;  Upscale or downscale the current best source data channel resolution
   ;  to match the target data channel resolution:
               IF ((target_resol EQ 275) AND $
                  (bst_src_resol_lnd[attempt] EQ 1100)) THEN BEGIN
                  src_rad = lr2hr(src_rad, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 210
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_radrd = lr2hr(src_radrd, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 211
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_brf = lr2hr(src_brf, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 212
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_rdqi = lr2hr(src_rdqi, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 213
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  source_mask = lr2hr(source_mask, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 214
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
               ENDIF
               IF ((target_resol EQ 1100) AND $
                  (bst_src_resol_lnd[attempt] EQ 275)) THEN BEGIN
                  src_rad = hr2lr(src_rad, 'Rad', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 215
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_radrd = hr2lr(src_radrd, 'Radrd', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 216
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_brf = hr2lr(src_brf, 'Brf', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 217
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_rdqi = hr2lr(src_rdqi, 'RDQI', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 218
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  source_mask = hr2lr(source_mask, 'Mask', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 219
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
               ENDIF
               IF (misr_mode EQ 'LM') THEN BEGIN
                  IF (N_ELEMENTS(source_mask) EQ (512 * 128)) THEN BEGIN
                     source_mask = lr2hr(source_mask, DEBUG = debug, $
                        EXCPT_COND = excpt_cond)
                     IF (debug AND (excpt_cond NE '')) THEN BEGIN
                        error_code = 220
                        excpt_cond = 'Error ' + strstr(error_code) + $
                           ' in ' + rout_name + ': ' + excpt_cond
                        RETURN, error_code
                     ENDIF
                  ENDIF
               ENDIF

   ;  Loop over the number of missing values over land masses in the target
   ;  data channel:
               nfixed = 0L
               nususrc = 0L
               nnegval = 0L
               n_miss_lnd = *n_miss_lnd_ptr[cam, bnd]
               idx_miss_lnd = *idx_miss_lnd_ptr[cam, bnd]
               fixed_rad = *fixed_rad_ptr[cam, bnd]
               fixed_rdqi = *fixed_rdqi_ptr[cam, bnd]
               fixed_radrd = *fixed_radrd_ptr[cam, bnd]
               fixed_brf = *fixed_brf_ptr[cam, bnd]

               FOR i = 0, n_miss_lnd - 1 DO BEGIN

   ;  Retrieve the Radiance value in the current best source databuffer at that
   ;  same location:
                  src_val = src_rad[idx_miss_lnd[i]]

   ;  Verify that the source value is valid, that its RDQI is less than 2 and
   ;  that it is also a clear land pixel; and if not proceed to the next missing
   ;  target value in need of processing:
                  IF ((src_radrd[idx_miss_lnd[i]] LE 65506U) AND $
                     (src_rdqi[idx_miss_lnd[i]] LT 2B) AND $
                     (source_mask[idx_miss_lnd[i]] EQ 1B)) THEN BEGIN

   ;  Compute the optimal replacement value based on the current best source
   ;  data channel:
                     good_val = bst_src_coefa_lnd[attempt] + $
                        bst_src_coefb_lnd[attempt] * src_val

   ;  Ensure the proposed radiance replacement value is positive, and if so
   ;  compute the estimated target radiance, Brf and RDQI:
                     IF (good_val GT 0.0) THEN BEGIN
                        fixed_rad[idx_miss_lnd[i]] = good_val
                        fixed_rdqi[idx_miss_lnd[i]] = 1B
                        fixed_radrd[idx_miss_lnd[i]] = $
                           UINT(ROUND(DOUBLE(good_val) / scalf))
                        fixed_radrd[idx_miss_lnd[i]] = $
                           fixed_radrd[idx_miss_lnd[i]] * 4 + $
                           fixed_rdqi[idx_miss_lnd[i]]
                        fixed_brf[idx_miss_lnd[i]] = $
                           good_val * convf[idx_miss_lnd[i]]
                        nfixed++
                     ENDIF ELSE BEGIN
                        nnegval++
                     ENDELSE
                  ENDIF ELSE BEGIN
                     nususrc++
                  ENDELSE
               ENDFOR

   ;  Report on the number of missing land values replaced:
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit, '# unusable source values: ', $
                     strstr(nususrc), FORMAT = fmt1
                  PRINTF, main_log_unit, '# unusable negative values: ', $
                     strstr(nnegval), FORMAT = fmt1
                  PRINTF, main_log_unit, '# missing land replaced: ', $
                     strstr(nfixed), FORMAT = fmt1
               ENDIF

   ;  Update the number and location of any remaining missing land values:
               idx_miss_lnd = WHERE((fixed_radrd eq 65523U) AND $
                  (target_mask EQ 1B), ntargetmiss_lnd)
               IF (ntargetmiss_lnd GT 0) THEN BEGIN
                  n_miss_lnd_ptr[cam, bnd] = PTR_NEW(ntargetmiss_lnd)
                  idx_miss_lnd_ptr[cam, bnd] = PTR_NEW(idx_miss_lnd)
               ENDIF ELSE BEGIN
                  n_miss_lnd_ptr[cam, bnd] = PTR_NEW(0L)
                  idx_miss_lnd_ptr[cam, bnd] = PTR_NEW(!NULL)
               ENDELSE
               fixed_rad_ptr[cam, bnd] = PTR_NEW(fixed_rad)
               fixed_rdqi_ptr[cam, bnd] = PTR_NEW(fixed_rdqi)
               fixed_radrd_ptr[cam, bnd] = PTR_NEW(fixed_radrd)
               fixed_brf_ptr[cam, bnd] = PTR_NEW(fixed_brf)
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit, '# remaining land missing: ', $
                     strstr(ntargetmiss_lnd), FORMAT = fmt1
               ENDIF
            ENDIF   ;  End of processing missing land values

   ;  ===============================================================
   ;  Process missing values over water bodies, if any:
            n_miss_wat = *n_miss_wat_ptr[cam, bnd]
            IF ((n_masks GT 1) AND (n_miss_wat GT 0)) THEN BEGIN

   ;  Retrieve the best camera name and number to replace missing values
   ;  over water bodies by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestWaterCameras
               bst_src_cam_nam_wat[attempt] = temp2[attempt]
               bst_src_cam_num_wat[attempt] = WHERE(misr_cams EQ $
                  bst_src_cam_nam_wat[attempt], cnt)
               IF (cnt EQ 1) THEN BEGIN
                  bst_src_cam_num_wat[attempt] = $
                     FIX(bst_src_cam_num_wat[attempt])
               ENDIF ELSE BEGIN
                  error_code = 230
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': Unrecognized camera name in ' + $
                     'retrieving best fits for missing water pixels.'
                  RETURN, error_code
               ENDELSE

   ;  Retrieve the best spectral band name and number to replace missing values
   ;  over water bodies by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestWaterBands
               bst_src_bnd_nam_wat[attempt] = temp2[attempt]
               bst_src_bnd_num_wat[attempt] = WHERE(misr_bnds EQ $
                  bst_src_bnd_nam_wat[attempt], cnt)
               IF (cnt EQ 1) THEN BEGIN
                  bst_src_bnd_num_wat[attempt] = $
                     FIX(bst_src_bnd_num_wat[attempt])
               ENDIF ELSE BEGIN
                  error_code = 232
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': Unrecognized spectral band name in ' + $
                     'retrieving best fits for missing water pixels.'
                  RETURN, error_code
               ENDELSE

   ;  Retrieve the corresponding statistics to replace missing values
   ;  over water bodies by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestWaterNpts
               bst_src_npts_wat[attempt] = temp2[attempt]

               temp2 = temp1.BestWaterRMSDs
               bst_src_rmsd_wat[attempt] = temp2[attempt]

               temp2 = temp1.BestWaterCors
               bst_src_corr_wat[attempt] = temp2[attempt]

               temp2 = temp1.BestWaterAs
               bst_src_coefa_wat[attempt] = temp2[attempt]

               temp2 = temp1.BestWaterBs
               bst_src_coefb_wat[attempt] = temp2[attempt]

               temp2 = temp1.BestWaterChisqs
               bst_src_chi_wat[attempt] = temp2[attempt]

   ;  Set the land/water/cloud mask for the current best source camera and
   ;  band to update the current target channel (an array with dimensions
   ;  equal to the corresponding source radiance array):
               source_mask = *lwc_mask_ptr[bst_src_cam_num_wat[attempt], $
                  bst_src_bnd_num_wat[attempt]]

   ;  Report on the plan to replace missing values in the current target:
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit
                  n_miss_wat = *n_miss_wat_ptr[cam, bnd]
                  PRINTF, main_log_unit, '# missing water values: ', $
                     strstr(n_miss_wat), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best source: ', $
                     bst_src_cam_nam_wat[attempt] + '/' + $
                     bst_src_bnd_nam_wat[attempt], FORMAT = fmt1
                  PRINTF, main_log_unit, '# common tgt/src data points: ', $
                     strstr(bst_src_npts_wat[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best Chi^2: ', $
                     strstr(bst_src_chi_wat[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best RMSD: ', $
                     strstr(bst_src_rmsd_wat[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best PCC: ', $
                     strstr(bst_src_corr_wat[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best fit equation: ', $
                     'target = ' + strstr(bst_src_coefa_wat[attempt]) + $
                     ' + ' + strstr(bst_src_coefb_wat[attempt]) + $
                     ' * source', FORMAT = fmt1
                  PRINTF, main_log_unit
               ENDIF

   ;  Access the L1B2 data for the current best source data channel:
               src_rad = *rad_ptr[bst_src_cam_num_wat[attempt], $
                  bst_src_bnd_num_wat[attempt]]
               src_radrd = *radrd_ptr[bst_src_cam_num_wat[attempt], $
                  bst_src_bnd_num_wat[attempt]]
               src_brf = *brf_ptr[bst_src_cam_num_wat[attempt], $
                  bst_src_bnd_num_wat[attempt]]
               src_rdqi = *rdqi_ptr[bst_src_cam_num_wat[attempt], $
                  bst_src_bnd_num_wat[attempt]]

   ;  Set the resolution of the current best source data channel:
               bst_src_resol_wat[attempt] = 275
               IF (misr_mode EQ 'GM') THEN BEGIN
                  IF ((bst_src_cam_nam_wat[attempt] NE 'AN') AND $
                     (bst_src_bnd_nam_wat[attempt] NE 'Red')) THEN $
                     bst_src_resol_wat[attempt] = 1100
               ENDIF

   ;  Upscale or downscale the current best source data channel resolution
   ;  to match the target data channel resolution:
               IF ((target_resol EQ 275) AND $
                  (bst_src_resol_wat[attempt] EQ 1100)) THEN BEGIN
                  src_rad = lr2hr(src_rad, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 240
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_radrd = lr2hr(src_radrd, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 241
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_brf = lr2hr(src_brf, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 242
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_rdqi = lr2hr(src_rdqi, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 243
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  source_mask = lr2hr(source_mask, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 244
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
               ENDIF
               IF ((target_resol EQ 1100) AND $
                  (bst_src_resol_wat[attempt] EQ 275)) THEN BEGIN
                  src_rad = hr2lr(src_rad, 'Rad', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 245
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_radrd = hr2lr(src_radrd, 'Radrd', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 246
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_brf = hr2lr(src_brf, 'Brf', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 247
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_rdqi = hr2lr(src_rdqi, 'RDQI', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 248
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  source_mask = hr2lr(source_mask, 'Mask', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 249
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
               ENDIF
               IF (misr_mode EQ 'LM') THEN BEGIN
                  IF (N_ELEMENTS(source_mask) EQ (512 * 128)) THEN BEGIN
                     source_mask = lr2hr(source_mask, DEBUG = debug, $
                        EXCPT_COND = excpt_cond)
                     IF (debug AND (excpt_cond NE '')) THEN BEGIN
                        error_code = 250
                        excpt_cond = 'Error ' + strstr(error_code) + $
                           ' in ' + rout_name + ': ' + excpt_cond
                        RETURN, error_code
                     ENDIF
                  ENDIF
               ENDIF

   ;  Loop over the number of missing values over water bodies in the target
   ;  data channel:
               nfixed = 0L
               nususrc = 0L
               nnegval = 0L
               n_miss_wat = *n_miss_wat_ptr[cam, bnd]
               idx_miss_wat = *idx_miss_wat_ptr[cam, bnd]
               fixed_rad = *fixed_rad_ptr[cam, bnd]
               fixed_rdqi = *fixed_rdqi_ptr[cam, bnd]
               fixed_radrd = *fixed_radrd_ptr[cam, bnd]
               fixed_brf = *fixed_brf_ptr[cam, bnd]

               FOR i = 0, n_miss_wat - 1 DO BEGIN

   ;  Retrieve the Radiance value in the current best source databuffer at that
   ;  same location:
                  src_val = src_rad[idx_miss_wat[i]]

   ;  Verify that the source value is valid, that its RDQI is less than 2 and
   ;  that it is also a clear water pixel; and if not proceed to the next
   ;  missing target value in need of processing:
                  IF ((src_radrd[idx_miss_wat[i]] LE 65506U) AND $
                     (src_rdqi[idx_miss_wat[i]] LT 2B) AND $
                     (source_mask[idx_miss_wat[i]] EQ 2B)) THEN BEGIN

   ;  Compute the optimal replacement value based on the current best source
   ;  data channel:
                     good_val = bst_src_coefa_wat[attempt] + $
                        bst_src_coefb_wat[attempt] * src_val

   ;  Ensure the proposed radiance replacement value is positive, and if so
   ;  compute the estimated target radiance, Brf and RDQI:
                     IF (good_val GT 0.0) THEN BEGIN
                        fixed_rad[idx_miss_wat[i]] = good_val
                        fixed_rdqi[idx_miss_wat[i]] = 1B
                        fixed_radrd[idx_miss_wat[i]] = $
                           UINT(ROUND(DOUBLE(good_val) / scalf))
                        fixed_radrd[idx_miss_wat[i]] = $
                           tgt_radrd[idx_miss_wat[i]] * 4 + $
                           tgt_rdqi[idx_miss_wat[i]]
                        fixed_brf[idx_miss_wat[i]] = $
                           good_val * convf[idx_miss_wat[i]]
                        nfixed++
                     ENDIF ELSE BEGIN
                        nnegval++
                     ENDELSE
                  ENDIF ELSE BEGIN
                     nususrc++
                  ENDELSE
               ENDFOR

   ;  Report on the number of missing water values replaced:
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit, '# unusable source values: ', $
                     strstr(nususrc), FORMAT = fmt1
                  PRINTF, main_log_unit, '# unusable negative values: ', $
                     strstr(nnegval), FORMAT = fmt1
                  PRINTF, main_log_unit, '# missing water replaced: ', $
                     strstr(nfixed), FORMAT = fmt1
               ENDIF

   ;  Update the number and location of any remaining missing water values:
               idx_miss_wat = WHERE((fixed_radrd eq 65523U) AND $
                  (target_mask EQ 2B), ntargetmiss_wat)
               IF (ntargetmiss_wat GT 0) THEN BEGIN
                  n_miss_wat_ptr[cam, bnd] = PTR_NEW(ntargetmiss_wat)
                  idx_miss_wat_ptr[cam, bnd] = PTR_NEW(idx_miss_wat)
               ENDIF ELSE BEGIN
                  n_miss_wat_ptr[cam, bnd] = PTR_NEW(0L)
                  idx_miss_wat_ptr[cam, bnd] = PTR_NEW(!NULL)
               ENDELSE
               fixed_rad_ptr[cam, bnd] = PTR_NEW(fixed_rad)
               fixed_rdqi_ptr[cam, bnd] = PTR_NEW(fixed_rdqi)
               fixed_radrd_ptr[cam, bnd] = PTR_NEW(fixed_radrd)
               fixed_brf_ptr[cam, bnd] = PTR_NEW(fixed_brf)
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit, '# remaining water missing: ', $
                     strstr(ntargetmiss_wat), FORMAT = fmt1
               ENDIF
            ENDIF   ;  End of processing missing water values

   ;  ===============================================================
   ;  Process missing values over cloud fields, if any:
            n_miss_cld = *n_miss_cld_ptr[cam, bnd]
            IF ((n_masks GT 2) AND (n_miss_cld GT 0)) THEN BEGIN

   ;  Retrieve the best camera name and number to replace missing values
   ;  over cloud fields by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestCloudCameras
               bst_src_cam_nam_cld[attempt] = temp2[attempt]
               bst_src_cam_num_cld[attempt] = WHERE(misr_cams EQ $
                  bst_src_cam_nam_cld[attempt], cnt)
               IF (cnt EQ 1) THEN BEGIN
                  bst_src_cam_num_cld[attempt] = $
                     FIX(bst_src_cam_num_cld[attempt])
               ENDIF ELSE BEGIN
                  error_code = 260
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': Unrecognized camera name in ' + $
                     'retrieving best fits for missing cloud pixels.'
                  RETURN, error_code
               ENDELSE

   ;  Retrieve the best spectral band name and number to replace missing values
   ;  over cloud fields by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestCloudBands
               bst_src_bnd_nam_cld[attempt] = temp2[attempt]
               bst_src_bnd_num_cld[attempt] = WHERE(misr_bnds EQ $
                  bst_src_bnd_nam_cld[attempt], cnt)
               IF (cnt EQ 1) THEN BEGIN
                  bst_src_bnd_num_cld[attempt] = $
                     FIX(bst_src_bnd_num_cld[attempt])
               ENDIF ELSE BEGIN
                  error_code = 262
                  excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                     rout_name + ': Unrecognized spectral band name in ' + $
                     'retrieving best fits for missing cloud pixels.'
                  RETURN, error_code
               ENDELSE

   ;  Retrieve the corresponding statistics to replace missing values
   ;  over cloud fields by new estimates with the current optimal source
   ;  data channel:
               temp1 = *best_fits_ptr[cam, bnd]
               temp2 = temp1.BestCloudNpts
               bst_src_npts_cld[attempt] = temp2[attempt]

               temp2 = temp1.BestCloudRMSDs
               bst_src_rmsd_cld[attempt] = temp2[attempt]

               temp2 = temp1.BestCloudCors
               bst_src_corr_cld[attempt] = temp2[attempt]

               temp2 = temp1.BestCloudAs
               bst_src_coefa_cld[attempt] = temp2[attempt]

               temp2 = temp1.BestCloudBs
               bst_src_coefb_cld[attempt] = temp2[attempt]

               temp2 = temp1.BestCloudChisqs
               bst_src_chi_cld[attempt] = temp2[attempt]

   ;  Set the land/water/cloud mask for the current best source camera and
   ;  band to update the current target channel (an array with dimensions
   ;  equal to the corresponding source radiance array):
               source_mask = *lwc_mask_ptr[bst_src_cam_num_cld[attempt], $
                  bst_src_bnd_num_cld[attempt]]

   ;  Report on the plan to replace missing values in the current target:
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit
                  n_miss_cld = *n_miss_cld_ptr[cam, bnd]
                  PRINTF, main_log_unit, '# missing cloud values: ', $
                     strstr(n_miss_cld), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best source: ', $
                     bst_src_cam_nam_cld[attempt] + '/' + $
                     bst_src_bnd_nam_cld[attempt], FORMAT = fmt1
                  PRINTF, main_log_unit, '# common tgt/src data points: ', $
                     strstr(bst_src_npts_cld[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best Chi^2: ', $
                     strstr(bst_src_chi_cld[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best RMSD: ', $
                     strstr(bst_src_rmsd_cld[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best PCC: ', $
                     strstr(bst_src_corr_cld[attempt]), FORMAT = fmt1
                  PRINTF, main_log_unit, 'Best fit equation: ', $
                     'target = ' + strstr(bst_src_coefa_cld[attempt]) + $
                     ' + ' + strstr(bst_src_coefb_cld[attempt]) + $
                     ' * source', FORMAT = fmt1
                  PRINTF, main_log_unit
               ENDIF

   ;  Access the L1B2 data for the current best source data channel:
               src_rad = *rad_ptr[bst_src_cam_num_cld[attempt], $
                  bst_src_bnd_num_cld[attempt]]
               src_radrd = *radrd_ptr[bst_src_cam_num_cld[attempt], $
                  bst_src_bnd_num_cld[attempt]]
               src_brf = *brf_ptr[bst_src_cam_num_cld[attempt], $
                  bst_src_bnd_num_cld[attempt]]
               src_rdqi = *rdqi_ptr[bst_src_cam_num_cld[attempt], $
                  bst_src_bnd_num_cld[attempt]]

   ;  Set the resolution of the current best source data channel:
               bst_src_resol_cld[attempt] = 275
               IF (misr_mode EQ 'GM') THEN BEGIN
                  IF ((bst_src_cam_nam_cld[attempt] NE 'AN') AND $
                     (bst_src_bnd_nam_cld[attempt] NE 'Red')) THEN $
                     bst_src_resol_cld[attempt] = 1100
               ENDIF

   ;  Upscale or downscale the current best source data channel resolution
   ;  to match the target data channel resolution:
               IF ((target_resol EQ 275) AND $
                  (bst_src_resol_cld[attempt] EQ 1100)) THEN BEGIN
                  src_rad = lr2hr(src_rad, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 270
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_radrd = lr2hr(src_radrd, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 271
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_brf = lr2hr(src_brf, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 272
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_rdqi = lr2hr(src_rdqi, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 273
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  source_mask = lr2hr(source_mask, DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 274
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
               ENDIF
               IF ((target_resol EQ 1100) AND $
                  (bst_src_resol_cld[attempt] EQ 275)) THEN BEGIN
                  src_rad = hr2lr(src_rad, 'Rad', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 275
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_radrd = hr2lr(src_radrd, 'Radrd', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 276
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_brf = hr2lr(src_brf, 'Brf', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 277
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  src_rdqi = hr2lr(src_rdqi, 'RDQI', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 278
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
                  source_mask = hr2lr(source_mask, 'Mask', DEBUG = debug, $
                     EXCPT_COND = excpt_cond)
                  IF (debug AND (excpt_cond NE '')) THEN BEGIN
                     error_code = 279
                     excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                        rout_name + ': ' + excpt_cond
                     RETURN, error_code
                  ENDIF
               ENDIF
               IF (misr_mode EQ 'LM') THEN BEGIN
                  IF (N_ELEMENTS(source_mask) EQ (512 * 128)) THEN BEGIN
                     source_mask = lr2hr(source_mask, DEBUG = debug, $
                        EXCPT_COND = excpt_cond)
                     IF (debug AND (excpt_cond NE '')) THEN BEGIN
                        error_code = 280
                        excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                           rout_name + ': ' + excpt_cond
                        RETURN, error_code
                     ENDIF
                  ENDIF
               ENDIF

   ;  Loop over the number of missing values over cloud fields in the target
   ;  data channel:
               nfixed = 0L
               nususrc = 0L
               nnegval = 0L
               n_miss_cld = *n_miss_cld_ptr[cam, bnd]
               idx_miss_cld = *idx_miss_cld_ptr[cam, bnd]
               fixed_rad = *fixed_rad_ptr[cam, bnd]
               fixed_rdqi = *fixed_rdqi_ptr[cam, bnd]
               fixed_radrd = *fixed_radrd_ptr[cam, bnd]
               fixed_brf = *fixed_brf_ptr[cam, bnd]

               FOR i = 0, n_miss_cld - 1 DO BEGIN

   ;  Retrieve the Radiance value in the current best source databuffer at that
   ;  same location:
                  src_val = src_rad[idx_miss_cld[i]]

   ;  Verify that the source value is valid, that its RDQI is less than 2 and
   ;  that it is also a cloud pixel; and if not proceed to the next missing
   ;  target value in need of processing:
                  IF ((src_radrd[idx_miss_cld[i]] LE 65506U) AND $
                     (src_rdqi[idx_miss_cld[i]] LT 2B) AND $
                     (source_mask[idx_miss_cld[i]] EQ 3B)) THEN BEGIN

   ;  Compute the optimal replacement value based on the current best source
   ;  data channel:
                     good_val = bst_src_coefa_cld[attempt] + $
                        bst_src_coefb_cld[attempt] * src_val

   ;  Ensure the proposed radiance replacement value is positive, and if so
   ;  compute the estimated target radiance, Brf and RDQI:
                     IF (good_val GT 0.0) THEN BEGIN
                        fixed_rad[idx_miss_cld[i]] = good_val
                        fixed_rdqi[idx_miss_cld[i]] = 1B
                        fixed_radrd[idx_miss_cld[i]] = $
                           UINT(ROUND(DOUBLE(good_val) / scalf))
                        fixed_radrd[idx_miss_cld[i]] = $
                           tgt_radrd[idx_miss_cld[i]] * 4 + $
                           tgt_rdqi[idx_miss_cld[i]]
                        fixed_brf[idx_miss_cld[i]] = $
                           good_val * convf[idx_miss_cld[i]]
                        nfixed++
                     ENDIF ELSE BEGIN
                        nnegval++
                     ENDELSE
                  ENDIF ELSE BEGIN
                     nususrc++
                  ENDELSE
               ENDFOR

   ;  Report on the number of missing cloud values replaced:
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit, '# unusable source values: ', $
                     strstr(nususrc), FORMAT = fmt1
                  PRINTF, main_log_unit, '# unusable negative values: ', $
                     strstr(nnegval), FORMAT = fmt1
                  PRINTF, main_log_unit, '# missing cloud replaced: ', $
                     strstr(nfixed), FORMAT = fmt1
               ENDIF

   ;  Update the number and location of any remaining missing cloud values:
              idx_miss_cld = WHERE((fixed_radrd eq 65523U) AND $
                 (target_mask EQ 3B), ntargetmiss_cld)
              IF (ntargetmiss_cld GT 0) THEN BEGIN
                 n_miss_cld_ptr[cam, bnd] = PTR_NEW(ntargetmiss_cld)
                 idx_miss_cld_ptr[cam, bnd] = PTR_NEW(idx_miss_cld)
              ENDIF ELSE BEGIN
                 n_miss_cld_ptr[cam, bnd] = PTR_NEW(0L)
                 idx_miss_cld_ptr[cam, bnd] = PTR_NEW(!NULL)
              ENDELSE
               fixed_rad_ptr[cam, bnd] = PTR_NEW(fixed_rad)
               fixed_rdqi_ptr[cam, bnd] = PTR_NEW(fixed_rdqi)
               fixed_radrd_ptr[cam, bnd] = PTR_NEW(fixed_radrd)
               fixed_brf_ptr[cam, bnd] = PTR_NEW(fixed_brf)
               IF (main_log_it) THEN BEGIN
                  PRINTF, main_log_unit, '# remaining cloud missing: ', $
                     strstr(ntargetmiss_cld), FORMAT = fmt1
               ENDIF
            ENDIF   ;  End of processing missing cloud values

   ;  Prepare for next attempt:
            attempt++

         ENDWHILE   ;  End of loop on attempts
      ENDFOR   ;  End of loop on spectral bands
   ENDFOR   ;  End of loop on cameras

   ;  Generate statistics and scatter plots of new estimates against missing
   ;  values

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
