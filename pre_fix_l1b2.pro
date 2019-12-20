FUNCTION pre_fix_l1b2, $
   misr_ptr, $
   radrd_ptr, $
   rad_ptr, $
   rdqi_ptr, $
   lwc_mask_ptr, $
   n_poor_lnd_ptr, $
   idx_poor_lnd_ptr, $
   n_poor_wat_ptr, $
   idx_poor_wat_ptr, $
   n_poor_cld_ptr, $
   idx_poor_cld_ptr, $
   n_miss_lnd_ptr, $
   idx_miss_lnd_ptr, $
   n_miss_wat_ptr, $
   idx_miss_wat_ptr, $
   n_miss_cld_ptr, $
   idx_miss_cld_ptr, $
   best_fits_ptr, $
   N_MASKS = n_masks, $
   ALSO_POOR = also_poor, $
   TEST_ID = test_id, $
   MAIN_LOG_IT = main_log_it, $
   MAIN_LOG_UNIT = main_log_unit, $
   LOG_IT = log_it, $
   LOG_FOLDER = log_folder, $
   SCATT_IT = scatt_it, $
   SCATT_FOLDER = scatt_folder, $
   SET_MIN_SCATT = set_min_scatt, $
   SET_MAX_SCATT = set_max_scatt, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function identifies the L1B2 databuffers of the
   ;  specified MISR BLOCK that contain missing or optionally poor data,
   ;  and computes the best linear fits statistics needed to replace those
   ;  values.
   ;
   ;  ALGORITHM: This function scans the radiance values (with the RDQI
   ;  attached) and the RDQI field for each camera and spectral band of
   ;  the specified MISR BLOCK, detects whether one or more of these 36
   ;  data channels contains poor or missing data values, loads
   ;  information on the numbers and locations of those values on the heap
   ;  and calls the best_fits_l1b2.pro function when required to compute
   ;  the optimal fitting functions for the appropriate land cover masks.
   ;  If the optional input keyword parameters MAIN_LOG_IT is set, this
   ;  function reports progress in the main output log file attached to
   ;  the IDL logical unit main_log_unit (assumed to be open prior to
   ;  calling this function).
   ;
   ;  SYNTAX: rc = pre_fix_l1b2(misr_ptr, radrd_ptr, $
   ;  rad_ptr, rdqi_ptr, lwc_mask_ptr, $
   ;  n_poor_lnd_ptr, idx_poor_lnd_ptr, $
   ;  n_poor_wat_ptr, idx_poor_wat_ptr, $
   ;  n_poor_cld_ptr, idx_poor_cld_ptr, $
   ;  n_miss_lnd_ptr, idx_miss_lnd_ptr, $
   ;  n_miss_wat_ptr, idx_miss_wat_ptr, $
   ;  n_miss_cld_ptr, idx_miss_cld_ptr, $
   ;  best_fits_ptr, N_MASKS = n_masks, $
   ;  ALSO_POOR = also_poor, TEST_ID = test_id, $
   ;  MAIN_LOG_IT = main_log_it, MAIN_LOG_UNIT = main_log_unit, $
   ;  LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;  SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
   ;  SET_MIN_SCATT = set_min_scatt, SET_MAX_SCATT = set_max_scatt, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_ptr {POINTER} [I]: The pointer to a STRING array containing
   ;      metadata on the MISR MODE, PATH, ORBIT and BLOCK of the next 3
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
   ;  *   rdqi_ptr {POINTER array} [O]: The array of 36 pointers to the
   ;      original MISR data buffers containing the BYTE L1B2 RDQI values,
   ;      in the native order (DF/Blue to DA/NIR).
   ;
   ;  *   lwc_mask_ptr {POINTER array} [I]: The array of 36 (9 cameras by
   ;      4 spectral bands) pointers to the BYTE masks containing the
   ;      information on the spatial distribution of geophysical media to
   ;      consider, as defined by n_masks.
   ;
   ;  *   n_poor_lnd_ptr {POINTER array} [O]: The array of pointers to the
   ;      number of poor pixel values over land masses in each of the 36
   ;      data channels of the input databuffer.
   ;
   ;  *   idx_poor_lnd_ptr {POINTER array} [O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      poor pixel values over land masses in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_poor_wat_ptr {POINTER array} [O]: The array of pointers to the
   ;      number of poor pixel values over water bodies in each of the 36
   ;      data channels of the input databuffer.
   ;
   ;  *   idx_poor_wat_ptr {POINTER array} [O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      poor pixel values over water bodies in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_poor_cld_ptr {POINTER array} [O]: The array of pointers to the
   ;      number of poor pixel values over cloud fields in each of the 36
   ;      data channels of the input databuffer.
   ;
   ;  *   idx_poor_cld_ptr {POINTER array} [O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      poor pixel values over cloud fields in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_miss_lnd_ptr {POINTER array} [O]: The array of pointers to the
   ;      number of missing pixel values over land masses in each of the
   ;      36 data channels of the input databuffer.
   ;
   ;  *   idx_miss_lnd_ptr {POINTER array} [O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      missing pixel values over land masses in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_miss_wat_ptr {POINTER array} [O]: The array of pointers to the
   ;      number of missing pixel values over water bodies in each of the
   ;      36 data channels of the input databuffer.
   ;
   ;  *   idx_miss_wat_ptr {POINTER array} [O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      missing pixel values over water bodies in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   n_miss_cld_ptr {POINTER array} [O]: The array of pointers to the
   ;      number of missing pixel values over cloud fields in each of the
   ;      36 data channels of the input databuffer.
   ;
   ;  *   idx_miss_cld_ptr {POINTER array} [O]: The array of pointers to
   ;      the vectors containing the one-dimensional subscripts of the
   ;      missing pixel values over cloud fields in each of the 36 data
   ;      channels of the input databuffer.
   ;
   ;  *   best_fits_ptr {POINTER array} [O]: The array of pointers to the
   ;      best fits statistics to replace poor or missing values in the 36
   ;      data channels of the input databuffer.
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
   ;  *   ALSO_POOR = also_poor {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) replacing poor L1B2 values (i.e., those
   ;      with RDQI = 2B) by new estimates.
   ;
   ;  *   TEST_ID = test_id {STRING} [I] (Default value: ”): String to
   ;      designate a particular experiment (e.g., to test the performance
   ;      of the algorithm), used in the names of output files.
   ;
   ;  *   MAIN_LOG_IT = main_log_it {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) writing intermediary results to a
   ;      pre-existing log file.
   ;
   ;  *   MAIN_LOG_UNIT = main_log_unit {IDL Logical Unit Number} [I] (Default: None):
   ;      The IDL Logical Unit Number of the main log file, which must be
   ;      opened for writing prior to calling this function.
   ;
   ;  *   LOG_IT = log_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating a log file for each call of the
   ;      best_fits_l1b2.pro function.
   ;
   ;  *   LOG_FOLDER = log_folder {STRING} [I]: The directory address of
   ;      the output folder containing the processing log for each call of
   ;      the best_fits_l1b2.pro function, if different from the value
   ;      implied by the default set by function set_roots_vers.pro) and
   ;      the routine arguments.
   ;
   ;  *   SCATT_IT = scatt_it {INT} [I] (Default value: 0): Flag to
   ;      generate (1) or skip (0) a scatterplot of the two best
   ;      correlated data channels for each of the cases specified by
   ;      n_masks.
   ;
   ;  *   SCATT_FOLDER = scatt_folder {STRING} [I]: The directory address
   ;      of the output folder containing the scatterplots, if different
   ;      from the value implied by the default set by function
   ;      set_roots_vers.pro) and the routine arguments.
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
   ;      provided in the call. The output positional parameters contain
   ;      the results generated by this function.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters may be incomplete or
   ;      incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: At least one of the following input positional
   ;      parameters is not a pointer: misr_ptr, radrd_ptr, rad_ptr,
   ;      rdqi_ptr, lwc_mask_ptr.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      best_fits_l1b2.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   best_fits_l1b2.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_pointer.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   strrepeat.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      [See the outcome(s) generated by fix_l1b2.pro]
   ;
   ;  REFERENCES:
   ;
   ;  *   Michel Verstraete, Linda Hunt and Veljko M. Jovanovic (2019)
   ;      _Improving the usability of the MISR L1B2 Georectified Radiance
   ;      Product (2000–present) in land surface applications_,
   ;      Earth System Science Data, Vol. xxx, p. yy–yy, available from
   ;      https://www.earth-syst-sci-data.net/essd-2019-zz/ (DOI:
   ;      10.5194/zzz).
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–02–28: Version 0.9 — Initial release of the function
   ;      fix_l1b2.pro, from which this function is derived.
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
   ;  *   2019–10–23: Version 2.2.0 — Major rewrite of the function
   ;      fix_l1b2.pro, breaking it up into smaller routines, including
   ;      this one; update the code to properly handle Local Mode data.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2019 Michel M. Verstraete.
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
   ;      be included in its entirety in all copies or substantial
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
   IF (KEYWORD_SET(also_poor)) THEN also_poor = 1 ELSE also_poor = 0
   IF (KEYWORD_SET(main_log_it)) THEN main_log_it = 1 ELSE main_log_it = 0
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
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
      n_reqs = 18
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_ptr, radrd_ptr, rad_ptr, ' + $
            'rdqi_ptr, lwc_mask_ptr, n_poor_lnd_ptr, idx_poor_lnd_ptr, ' + $
            'n_poor_wat_ptr, idx_poor_wat_ptr, n_poor_cld_ptr, ' + $
            'idx_poor_cld_ptr, n_miss_lnd_ptr, idx_miss_lnd_ptr, ' + $
            'n_miss_wat_ptr, idx_miss_wat_ptr, n_miss_cld_ptr, ' + $
            'idx_miss_cld_ptr, best_fits_ptr.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if anyone of the
   ;  input positional parameters 'misr_ptr', 'radrd_ptr', 'rad_ptr',
   ;  'rdqi_ptr', or 'lwc_mask_ptr' is not a pointer:
      res1 = is_pointer(misr_ptr)
      res2 = is_pointer(radrd_ptr)
      res3 = is_pointer(rad_ptr)
      res4 = is_pointer(rdqi_ptr)
      res5 = is_pointer(lwc_mask_ptr)
      IF ((res1 NE 1) OR (res2 NE 1) OR (res3 NE 1) OR $
         (res4 NE 1) OR (res5 NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': At least one of the following input positional parameters ' + $
            'is not a pointer: misr_ptr, radrd_ptr, rad_ptr, rdqi_ptr, ' + $
            'lwc_mask_ptr.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   misr_cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames

   ;  Retrieve the MISR Mode, Path, Orbit, Block and Version identifiers from
   ;  the input positional parameter 'misr_ptr':
   temp = *misr_ptr
   misr_mode = temp[0]
   misr_path_str = temp[1]
   misr_orbit_str = temp[2]
   misr_block_str = temp[3]
   misr_version = temp[4]

   ;  Define the output pointer variables and arrays containing the numbers
   ;  and locations of the poor values:
   n_poor_lnd_ptr = PTRARR(n_cams, n_bnds)
   idx_poor_lnd_ptr = PTRARR(n_cams, n_bnds)
   n_poor_wat_ptr = PTRARR(n_cams, n_bnds)
   idx_poor_wat_ptr = PTRARR(n_cams, n_bnds)
   n_poor_cld_ptr = PTRARR(n_cams, n_bnds)
   idx_poor_cld_ptr = PTRARR(n_cams, n_bnds)

   ;  Define the output pointer variables and arrays containing the numbers
   ;  and locations of the missing values:
   n_miss_lnd_ptr = PTRARR(n_cams, n_bnds)
   idx_miss_lnd_ptr = PTRARR(n_cams, n_bnds)
   n_miss_wat_ptr = PTRARR(n_cams, n_bnds)
   idx_miss_wat_ptr = PTRARR(n_cams, n_bnds)
   n_miss_cld_ptr = PTRARR(n_cams, n_bnds)
   idx_miss_cld_ptr = PTRARR(n_cams, n_bnds)

   ;  Define the output pointer array containing the results from the best fits:
   best_fits_ptr = PTRARR(n_cams, n_bnds)

   fmt1 = '(A30, A)'

   ;  Loop over the target cameras and spectral bands by number, in the
   ;  natural MISR order:
   FOR cam = 0, n_cams - 1 DO BEGIN

      IF (verbose GT 0) THEN BEGIN
         IF (also_poor) THEN BEGIN
            PRINT, '   ***   Scanning camera ' + misr_cams[cam] + $
               ' for poor and missing values.'
         ENDIF ELSE BEGIN
            PRINT, '   ***   Scanning camera ' + misr_cams[cam] + $
               ' for missing values.'
         ENDELSE
      ENDIF

      FOR bnd = 0, n_bnds - 1 DO BEGIN

         IF (main_log_it) THEN PRINTF, main_log_unit, strrepeat('-', 40)

   ;  Generate the corresponding target data channel name:
         cam_bnd = misr_cams[cam] + '_' + misr_bnds[bnd]

   ;  Access the L1B2 radiance, RDQI and land cover mask data for the current
   ;  target data channel:
         tgt_rad = *rad_ptr[cam, bnd]
         tgt_radrd = *radrd_ptr[cam, bnd]
         tgt_rdqi = *rdqi_ptr[cam, bnd]

   ;  Access the land cover mask for the current camera and spectral band,
   ;  and upscale it if necessary when processing Local Mode data:
         tgt_mask = *lwc_mask_ptr[cam, bnd]
         IF ((misr_mode EQ 'LM') AND (cam NE 4) AND (bnd NE 2)) THEN BEGIN
            tgt_mask = lr2hr(tgt_mask)
         ENDIF

   ;  Establish whether the current target data channel contains any poor
   ;  data identified by an RDQI of 2B, and pretend there are no poor data
   ;  values if the keyword parameter also_poor is not set:
         npoor = 0L
         nmiss = 0L
         IF (also_poor) THEN BEGIN
            idx_poor_lnd = WHERE(((tgt_rdqi EQ 2B) AND $
               (tgt_mask EQ 1B)), npoorlnd)
            IF (npoorlnd GT 0) THEN BEGIN
               npoor = npoor + npoorlnd
               n_poor_lnd_ptr[cam, bnd] = PTR_NEW(npoorlnd)
               idx_poor_lnd_ptr[cam, bnd] = PTR_NEW(idx_poor_lnd)
            ENDIF ELSE BEGIN
               n_poor_lnd_ptr[cam, bnd] = PTR_NEW(0L)
               idx_poor_lnd_ptr[cam, bnd] = PTR_NEW(!NULL)
            ENDELSE

            idx_poor_wat = WHERE(((tgt_rdqi EQ 2B) AND $
               (tgt_mask EQ 2B)), npoorwat)
            IF (npoorwat GT 0) THEN BEGIN
               npoor = npoor + npoorwat
               n_poor_wat_ptr[cam, bnd] = PTR_NEW(npoorwat)
               idx_poor_wat_ptr[cam, bnd] = PTR_NEW(idx_poor_wat)
            ENDIF ELSE BEGIN
               n_poor_wat_ptr[cam, bnd] = PTR_NEW(0L)
               idx_poor_wat_ptr[cam, bnd] = PTR_NEW(!NULL)
            ENDELSE

            idx_poor_cld = WHERE(((tgt_rdqi EQ 2B) AND $
               (tgt_mask EQ 3B)), npoorcld)
            IF (npoorcld GT 0) THEN BEGIN
               npoor = npoor + npoorcld
               n_poor_cld_ptr[cam, bnd] = PTR_NEW(npoorcld)
               idx_poor_cld_ptr[cam, bnd] = PTR_NEW(idx_poor_cld)
            ENDIF ELSE BEGIN
               n_poor_cld_ptr[cam, bnd] = PTR_NEW(0L)
               idx_poor_cld_ptr[cam, bnd] = PTR_NEW(!NULL)
            ENDELSE
         ENDIF ELSE BEGIN
            n_poor_lnd_ptr[cam, bnd] = PTR_NEW(0L)
            idx_poor_lnd_ptr[cam, bnd] = PTR_NEW(!NULL)
            n_poor_wat_ptr[cam, bnd] = PTR_NEW(0L)
            idx_poor_wat_ptr[cam, bnd] = PTR_NEW(!NULL)
            n_poor_cld_ptr[cam, bnd] = PTR_NEW(0L)
            idx_poor_cld_ptr[cam, bnd] = PTR_NEW(!NULL)
         ENDELSE

   ;  Establish whether the current target data channel contains any missing
   ;  data identified by the scaled radiance value of 65523U:
         nmiss = 0L
         idx_miss_lnd = WHERE(((tgt_radrd EQ 65523U) AND $
            (tgt_mask EQ 1B)), nmisslnd)
         IF (nmisslnd GT 0) THEN BEGIN
            nmiss = nmiss + nmisslnd
            n_miss_lnd_ptr[cam, bnd] = PTR_NEW(nmisslnd)
            idx_miss_lnd_ptr[cam, bnd] = PTR_NEW(idx_miss_lnd)
         ENDIF ELSE BEGIN
            n_miss_lnd_ptr[cam, bnd] = PTR_NEW(0L)
            idx_miss_lnd_ptr[cam, bnd] = PTR_NEW(!NULL)
         ENDELSE

         idx_miss_wat = WHERE(((tgt_radrd EQ 65523U) AND $
            (tgt_mask EQ 2B)), nmisswat)
         IF (nmisswat GT 0) THEN BEGIN
            nmiss = nmiss + nmisswat
            n_miss_wat_ptr[cam, bnd] = PTR_NEW(nmisswat)
            idx_miss_wat_ptr[cam, bnd] = PTR_NEW(idx_miss_wat)
         ENDIF ELSE BEGIN
            n_miss_wat_ptr[cam, bnd] = PTR_NEW(0L)
            idx_miss_wat_ptr[cam, bnd] = PTR_NEW(!NULL)
         ENDELSE

         idx_miss_cld = WHERE(((tgt_radrd EQ 65523U) AND $
            (tgt_mask EQ 3B)), nmisscld)
         IF (nmisscld GT 0) THEN BEGIN
            nmiss = nmiss + nmisscld
            n_miss_cld_ptr[cam, bnd] = PTR_NEW(nmisscld)
            idx_miss_cld_ptr[cam, bnd] = PTR_NEW(idx_miss_cld)
         ENDIF ELSE BEGIN
            n_miss_cld_ptr[cam, bnd] = PTR_NEW(0L)
            idx_miss_cld_ptr[cam, bnd] = PTR_NEW(!NULL)
         ENDELSE

   ;  Report the initial number of missing values, and optionally the number of
   ;  poor values in the log file:
         IF (main_log_it) THEN BEGIN
            PRINTF, main_log_unit, 'Target data channel: ', cam_bnd, $
               FORMAT = fmt1
            IF (also_poor) THEN BEGIN
               PRINTF, main_log_unit, '# poor lnd values: ', $
                  strstr(*n_poor_lnd_ptr[cam, bnd]), FORMAT = fmt1
               IF (n_masks GT 1) THEN BEGIN
                  PRINTF, main_log_unit, '# poor wat values: ', $
                     strstr(*n_poor_wat_ptr[cam, bnd]), FORMAT = fmt1
               ENDIF
               IF (n_masks GT 2) THEN BEGIN
                  PRINTF, main_log_unit, '# poor cld values: ', $
                     strstr(*n_poor_cld_ptr[cam, bnd]), FORMAT = fmt1
               ENDIF
            ENDIF
            PRINTF, main_log_unit, '# missing lnd values: ', $
               strstr(*n_miss_lnd_ptr[cam, bnd]), FORMAT = fmt1
            IF (n_masks GT 1) THEN BEGIN
               PRINTF, main_log_unit, '# missing wat values: ', $
                  strstr(*n_miss_wat_ptr[cam, bnd]), FORMAT = fmt1
            ENDIF
            IF (n_masks GT 2) THEN BEGIN
               PRINTF, main_log_unit, '# missing cld values: ', $
                  strstr(*n_miss_cld_ptr[cam, bnd]), FORMAT = fmt1
            ENDIF
         ENDIF

   ;  If neither poor nor missing values need to be replaced, set the best
   ;  fit statistics pointer to a null pointer and proceed to the next camera
   ;  and spectral band:
         IF ((npoor EQ 0) AND (nmiss EQ 0)) THEN BEGIN
            best_fits_ptr[cam, bnd] = PTR_NEW(!NULL)

            IF (verbose GT 0) THEN BEGIN
               PRINT, 'Skipping camera ' + cam_bnd + ' (nothing to do).'
               PRINT
            ENDIF

            CONTINUE
         ENDIF

   ;  Compute the best linear fit equations to predict values in the current
   ;  target data channel on the basis of the other 35 source channels:
         rc = best_fits_l1b2(misr_ptr, rad_ptr, rdqi_ptr, misr_cams[cam], $
            misr_bnds[bnd], n_masks, lwc_mask_ptr, best_fits, $
            TEST_ID = test_id, LOG_IT = log_it, LOG_FOLDER = log_folder, $
            SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
            SET_MIN_SCATT = set_min_scatt, SET_MAX_SCATT = set_max_scatt, $
            VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (debug AND (rc NE 0)) THEN BEGIN
            error_code = 500
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
                  ': ' + excpt_cond
            RETURN, error_code
         ENDIF

   ;  Load the best fits results on the heap:
         best_fits_ptr[cam, bnd] = PTR_NEW(best_fits)

      ENDFOR   ;  End of loop on spectral bands
   ENDFOR   ;  End of loop on cameras

   RETURN, return_code

END
