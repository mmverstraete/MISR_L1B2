FUNCTION best_fits_l1b2, $
   misr_ptr, $
   rad_ptr, $
   rdqi_ptr, $
   target_camera, $
   target_band, $
   n_masks, $
   lwc_mask_ptr, $
   best_fits, $
   TEST_ID = test_id, $
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
   ;  PURPOSE: This function generates statistical information, including
   ;  best linear fits, that can be used to estimate replacement values
   ;  for poor or bad (missing) values in the target MISR L1B2 radiance
   ;  array identified by the selected MODE, PATH, ORBIT, BLOCK, CAMERA
   ;  and BAND, based on non-missing values available in one of the other
   ;  35 source (camera and band) radiance data channels for the same
   ;  MODE, PATH, ORBIT and BLOCK data acquisition.
   ;
   ;  ALGORITHM: This function computes the Pearson correlation
   ;  coefficients, best linear fits and associated statistical parameters
   ;  between the target data channel radiance and all other (35) source
   ;  data channel radiances available for the selected MISR MODE, PATH,
   ;  ORBIT and BLOCK data acquisition. Depending on the value of the
   ;  input positional parameter n_masks, these statistics may be computed
   ;  for all available values in the source and target data channels
   ;  (n_masks set to 1), separately for land masses and water bodies
   ;  (n_masks set to 2), or separately for clear land masses, clear water
   ;  bodies and cloud fields.
   ;
   ;  SYNTAX: rc = best_fits_l1b2(misr_ptr, rad_ptr, rdqi_ptr, $
   ;  target_camera, target_band, n_masks, lwc_mask_ptr, best_fits, $
   ;  TEST_ID = test_id, LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;  SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
   ;  SET_MIN_SCATT = set_min_scatt, SET_MAX_SCATT = set_max_scatt, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_ptr {POINTER} [O]: The pointer to a STRING array containing
   ;      metadata on the MISR MODE, PATH, ORBIT and BLOCK of the next 4
   ;      pointer arrays.
   ;
   ;  *   rad_ptr {POINTER array} [O]: The array of 36 pointers to the
   ;      data buffers containing the FLOAT L1B2 radiance values, in the
   ;      native order (DF to DA).
   ;
   ;  *   rdqi_ptr {POINTER array} [O]: The array of 36 pointers to the
   ;      data buffers containing the BYTE L1B2 RDQI values, in the native
   ;      order (DF to DA).
   ;
   ;  *   target_camera {STRING} [I]: The selected MISR CAMERA (target).
   ;
   ;  *   target_band {STRING} [I]: The selected MISR BAND (target).
   ;
   ;  *   n_masks {INTEGER} [I]: The number of masks to use: 1 to compute
   ;      bulk statistics for all geophysical target types, 2 to compute
   ;      statistics separately for land masses and water bodies, or 3 to
   ;      compute statistics separately for clear land masses, clear water
   ;      bodies and cloud fields.
   ;
   ;  *   lwc_mask_ptr {POINTER array} [I]: The array of 36 (9 cameras by
   ;      4 spectral bands) pointers to the BYTE masks containing the
   ;      information on the spatial distribution of geophysical media to
   ;      consider, as defined by n_masks.
   ;
   ;  *   best_fits {STRUCTURE} [O]: The output structure containing the
   ;      desired statistical information.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   TEST_ID = test_id {STRING} [I] (Default value: ”): String to
   ;      designate a particular experiment (e.g., to test the performance
   ;      of the algorithm). This optional input keyword parameter has no
   ;      effect on the computing carried out by this function, but
   ;      modifies (when not a null string) the name of the folders that
   ;      contain the log file and the scatterplots, so that the results
   ;      can be compared to other cases.
   ;
   ;  *   LOG_IT = log_it {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) generating a log file.
   ;
   ;  *   LOG_FOLDER = log_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the output folder
   ;      containing the processing log.
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
   ;      provided in the call. If the input positional parameter n_masks
   ;      is set to 1, all valid values that are common to the source and
   ;      the target data channels are used; if it is set to 2, those
   ;      statistics are computed separately for the land areas and water
   ;      bodies, as classified by the corresponding static MISR AGP maps;
   ;      and if it is set to 3, those statistics are computed separately
   ;      for the clear land masses, the clear water bodies, and the
   ;      cloudy fields in the scene. The output positional parameter
   ;      best_fits contains the desired statistical information and the
   ;      scatterplots as well as the log file have been saved if
   ;      requested.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter best_fits may be empty
   ;      and the scatterplots as well as the log file may be inexistent,
   ;      incomplete or useless.
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
   ;  *   Error 120: The input positional parameter rad_ptr is not a
   ;      pointer array.
   ;
   ;  *   Error 122: The input positional parameter rdqi_ptr is not a
   ;      pointer array.
   ;
   ;  *   Error 130: Input positional parameter target_camera is invalid.
   ;
   ;  *   Error 132: Input positional parameter target_band is invalid.
   ;
   ;  *   Error 140: Input positional parameter n_masks is not an integer.
   ;
   ;  *   Error 142: The numerical value of the input positional parameter
   ;      n_masks is invalid.
   ;
   ;  *   Error 150: The input positional parameter lwc_mask_ptr is not a
   ;      pointer array.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 299: Unrecognized computer and alternate input or output
   ;      folders not provided.
   ;
   ;  *   Error 400: The directory log_fpath is unwritable.
   ;
   ;  *   Error 410: The directory scatt_fpath is unwritable.
   ;
   ;  *   Error 500: The dimensions of the target and the source data
   ;      buffers are incompatible.
   ;
   ;  *   Error 510: An exception condition occurred in plt_scatt_gen.pro
   ;      while generating scatterplots for land masses.
   ;
   ;  *   Error 520: An exception condition occurred in plt_scatt_gen.pro
   ;      while generating scatterplots for water bodies.
   ;
   ;  *   Error 530: An exception condition occurred in plt_scatt_gen.pro
   ;      while generating scatterplots for cloud fields.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_band.pro
   ;
   ;  *   chk_misr_camera.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_pointer.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   plt_scatt_gen.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
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
   ;  *   NOTE 1: This function returns the results in decreasing order of
   ;      the Pearson correlation coefficient between the source and the
   ;      target.
   ;
   ;  *   NOTE 2: If the optional keyword parameter SCATT_IT is set and
   ;      either or both of the optional keyword parameters SET_MIN_SCATT
   ;      and SET_MAX_SCATT are explicitly provided, the latter are used
   ;      for both the X and the Y axes, and for all (up to 3)
   ;      scatterplots simultaneously generated by this function: this
   ;      facilitates comparisons, but may result in some of the data
   ;      being clustered in a small subset of the imposed range. If these
   ;      keywords are not set, the ranges are individually selected to
   ;      optimize the visualization of the data in each figure.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_mode = 'GM'
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 1412
   ;      IDL> misr_block = 111
   ;      IDL> n_targets = 3
   ;      IDL> rccm_folder = ''
   ;      IDL> rccm_version = ''
   ;      IDL> debug = 1
   ;      IDL> rc = mk_l1b2_masks(misr_mode, misr_path, misr_orbit, $
   ;      IDL>    misr_block, n_targets, land_mask, water_mask, $
   ;      IDL>    clear_land_masks, clear_water_masks, cloud_masks, $
   ;      IDL>    RCCM_FOLDER = rccm_folder, RCCM_VERSION = rccm_version, $
   ;      IDL>    DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;      IDL> target_camera = 'AF'
   ;      IDL> target_band = 'Blue'
   ;      IDL> log_it = 1
   ;      IDL> log_folder = ''
   ;      IDL> scatt_it = 1
   ;      IDL> scatt_folder = ''
   ;      IDL> verbose = 2
   ;      IDL> rc = best_fits_l1b2(misr_mode, misr_path, misr_orbit, $
   ;      IDL>    misr_block, target_camera, target_band, n_targets, $
   ;      IDL>    land_mask, water_mask, clear_land_masks, $
   ;      IDL>    clear_water_masks, cloud_masks, best_fits, $
   ;      IDL>    LOG_IT = log_it, LOG_FOLDER = log_folder, $
   ;      IDL>    SCATT_IT = scatt_it, SCATT_FOLDER = scatt_folder, $
   ;      IDL>    VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      The scatterplot has been saved in ~/MISR_HR/Outcomes/
   ;         GM-P168-O001412-B111/BestFits/Bestfits_Nm3_ClearLand_.png
   ;      The scatterplot has been saved in ~/MISR_HR/Outcomes/
   ;         GM-P168-O001412-B111/BestFits/Bestfits_Nm3_ClearWater_.png
   ;      The scatterplot has been saved in ~/MISR_HR/Outcomes/
   ;         GM-P168-O001412-B111/BestFits/Bestfits_Nm3_Cloud_.png
   ;      The log file has been saved in ~/MISR_HR/Outcomes/
   ;         GM-P168-O001412-B111/BestFits/Bestfits_Nmasks3_L1B2_Rad_
   ;         GM-P168-O001412-B111_AF_Blue.txt
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
   ;  *   2018–08–09: Version 0.8 — Initial release.
   ;
   ;  *   2018–09–19: Version 0.9 — Upgrade the code to compute the
   ;      statistics only on valid data, i.e., where Rad > 0.0 (as before)
   ;      and RDQI < 2 (new), and to generate nominal results whenever
   ;      there are no common valid pixel values suitable to compute the
   ;      statistics.
   ;
   ;  *   2019–01–26: Version 1.0 — Bug fixes and initial public release.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.10 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–04–06: Version 2.11 — Update the code to use the more
   ;      detailed masks generated by the latest version of
   ;      mk_l1b2_masks.pro.
   ;
   ;  *   2019–04–18: Version 2.12 — Update the code to return negative
   ;      values for the RMSD and χ² statistics when there are no valid
   ;      data available.
   ;
   ;  *   2019–06-11: Version 2.13 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–09–30: Version 2.1.1 — Add the optional keyword parameter
   ;      test_id to facilitate saving the log file and the scatterplots
   ;      in separate folders for testing purposes, change the definition
   ;      of best_land_chisqs, best_water_chisqs and best_cloud_chisqs
   ;      from FLTARR to DBLARR and update the code to use the current
   ;      version of the function hr2lr.pro.
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
   ;
   ;  *   2020–05–02: Version 2.1.6 — Update the documentation.
   ;
   ;  *   2020–05–10: Version 2.1.7 — Software version described in the
   ;      peer-reviewed paper published in \textit{ESSD} referenced above.
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
   IF (KEYWORD_SET(log_it)) THEN log_it = 1 ELSE log_it = 0
   IF (KEYWORD_SET(scatt_it)) THEN scatt_it = 1 ELSE scatt_it = 0
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
      n_reqs = 8
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_ptr, rad_ptr, rdqi_ptr, ' + $
            'target_camera, target_band, n_masks, lwc_mask_ptr, best_fits.'
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
   ;  positional parameter 'radrd_ptr' is not a pointer array:
      IF ((is_pointer(rad_ptr) NE 1) OR (is_array(rad_ptr) NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter rad_ptr is not a ' + $
            'pointer array.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'rdqi_ptr' is not a pointer array:
      IF ((is_pointer(rdqi_ptr) NE 1) OR (is_array(rdqi_ptr) NE 1)) THEN BEGIN
         error_code = 122
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter rdqi_ptr is not a ' + $
            'pointer array.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'target_camera' is invalid:
      rc = chk_misr_camera(target_camera, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'target_band' is invalid:
      rc = chk_misr_band(target_band, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 132
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_masks' is not an integer:
      IF (is_integer(n_masks) NE 1) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter n_masks is not an integer.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_masks' is invalid (0 < n_masks < 4):
      IF ((n_masks LT 1) OR (n_masks GT 3)) THEN BEGIN
         error_code = 142
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The numerical value of the input positional parameter ' + $
            'n_masks is invalid.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lwc_mask_ptr' is not a pointer array:
      IF ((is_pointer(lwc_mask_ptr) NE 1) OR (is_array(lwc_mask_ptr) NE 1)) $
         THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lwc_mask_ptr is not a ' + $
            'pointer array.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications and the natural number of the target camera:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   n_bnds = misr_specs.NBands
   misr_cams = misr_specs.CameraNames
   misr_bnds = misr_specs.BandNames
   n_chns = misr_specs.NChannels

   idx = WHERE(misr_specs.CameraNames EQ target_camera, count)
   tgt_cam_num = idx[0]
   idx = WHERE(misr_specs.BandNames EQ target_band, count)
   tgt_bnd_num = idx[0]

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

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Retrieve the MISR Mode, Path, Orbit, Block and Version identifiers:
   temp = *misr_ptr
   misr_mode = temp[0]
   misr_path_str = temp[1]
   misr_orbit_str = temp[2]
   misr_block_str = temp[3]
   misr_version = temp[4]

   pob_str = misr_path_str + '-' + misr_orbit_str + '-' + misr_block_str
   mpob_str = misr_mode + '-' + misr_path_str + '-' + $
      misr_orbit_str + '-' + misr_block_str
   mpob_str_space = mpob_str.Replace('-', ' ')
   mpobcb_str = mpob_str + '-' + target_camera  + '-' + target_band

   ;  Retrieve the numerical versions of the MISR Path, Orbit, Block:
   rc = str2path(misr_path_str, misr_path)
   rc = str2orbit(misr_orbit_str, misr_orbit)
   rc = str2block(misr_block_str, misr_block)

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(misr_orbit)

   ;  Return to the calling routine with an error message if the routine
   ;  set_roots_vers.pro could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF ((log_it AND (~KEYWORD_SET(log_folder))) OR $
         (scatt_it AND (~KEYWORD_SET(scatt_folder)))) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And at least one of the optional input ' + $
            'keyword parameters log_folder, scatt_folder is not set.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the directory address of the folder containing the output log file,
   ;  if required:
   IF (log_it) THEN BEGIN
      IF (KEYWORD_SET(log_folder)) THEN BEGIN
         log_fpath = log_folder
      ENDIF ELSE BEGIN
         log_fpath = root_dirs[3] + pob_str + PATH_SEP() + $
            misr_mode + PATH_SEP() + 'L1B2' + PATH_SEP() + 'BestFits'

   ;  Update the save path if this is a test run:
         IF (test_id NE '') THEN log_fpath = log_fpath + '_' + test_id
      ENDELSE
      rc = force_path_sep(log_fpath)

   ;  Create the output directory 'log_fpath' if it does not exist, and
   ;  return to the calling routine with an error message if it is unwritable:
      res = is_writable_dir(log_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory log_fpath is unwritable.'
         RETURN, error_code
      ENDIF

   ;  Generate the specification of the output log file:
      log_fname = 'Log_Bestfit_Nm' + strstr(n_masks) + '_L1B2-Rad_' + $
         mpobcb_str + '_' + acquis_date + '_' + date + '.txt'
      log_fspec = log_fpath + log_fname
   ENDIF

   ;  Set the directory address of the folder containing the scatterplots,
   ;  if required:
   IF (scatt_it) THEN BEGIN
      IF (KEYWORD_SET(scatt_folder)) THEN BEGIN
         scatt_fpath = scatt_folder
      ENDIF ELSE BEGIN
         scatt_fpath = root_dirs[3] + pob_str + PATH_SEP() + $
            misr_mode + PATH_SEP() + 'L1B2' + PATH_SEP() + 'BestFits'

   ;  Update the save path if this is a test run:
         IF (test_id NE '') THEN scatt_fpath = scatt_fpath + '_' + test_id
      ENDELSE
      rc = force_path_sep(scatt_fpath)

   ;  Create the output directory 'scatt_fpath' if it does not exist, and
   ;  return to the calling routine with an error message if it is unwritable:
      res = is_writable_dir(scatt_fpath, /CREATE)
      IF (debug AND (res NE 1)) THEN BEGIN
         error_code = 410
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The directory scatt_fpath is unwritable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Retrieve the target Radiance data buffer:
   target_databuf = *rad_ptr[tgt_cam_num, tgt_bnd_num]

   ;  Retrieve the target RDQI data bufer:
   target_databuf_rd = *rdqi_ptr[tgt_cam_num, tgt_bnd_num]

   ;  Set the resolution of the target data channel (a flag used later on to
   ;  downscale or upscale data fields as appropriate):
   target_resol = 275
   IF (misr_mode EQ 'GM') THEN BEGIN
      IF ((target_camera NE 'AN') AND (target_band NE 'Red')) THEN $
         target_resol = 1100
   ENDIF

   ;  Retrieve the applicable mask for the target camera and band, and generate
   ;  the target land, and optionally water and cloud masks:
   target_mask = *lwc_mask_ptr[tgt_cam_num, tgt_bnd_num]
   IF (target_resol EQ 275) THEN target_land_mask = BYTARR(2048, 512) $
      ELSE target_land_mask = BYTARR(512, 128)
   tldx = WHERE(target_mask EQ 1B, count_tl)
   IF (count_tl GT 0) THEN target_land_mask[tldx] = 1B

   IF (n_masks GT 1) THEN BEGIN
      IF (target_resol EQ 275) THEN target_water_mask = BYTARR(2048, 512) $
         ELSE target_water_mask = BYTARR(512, 128)
      twdx = WHERE(target_mask EQ 2B, count_tw)
      IF (count_tw GT 0) THEN target_water_mask[twdx] = 2B
   ENDIF
   IF (n_masks GT 2) THEN BEGIN
      IF (target_resol EQ 275) THEN target_cloud_mask = BYTARR(2048, 512) $
         ELSE target_cloud_mask = BYTARR(512, 128)
      tcdx = WHERE(target_mask EQ 3B, count_tc)
      IF (count_tc GT 0) THEN target_cloud_mask[tcdx] = 3B
   ENDIF

   ;  Start generating the log file, if requested:
   IF (log_it) THEN BEGIN
      fmt1 = '(A30, A)'
      fmt2 = '(2(A6, 2X), A6, 2X, 4(A12, 2X), A14, 2X, A8)'
      fmt3 = '(2(A6, 2X), I6, 2X, 4(F12.4, 2X), F14.4, 2X, F8.3)'

      OPENW, log_unit, log_fspec, /GET_LUN
      PRINTF, log_unit, 'File name: ', FILE_BASENAME(log_fspec), FORMAT = fmt1
      PRINTF, log_unit, 'Folder name: ', FILE_DIRNAME(log_fspec, $
         /MARK_DIRECTORY), FORMAT = fmt1
      PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, log_unit, 'Saved on: ', date_time, FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Date of MISR acquisition: ', acquis_date, $
         FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'MISR Mode: ', misr_mode, FORMAT = fmt1
      PRINTF, log_unit, 'MISR Path: ', strstr(misr_path), FORMAT = fmt1
      PRINTF, log_unit, 'MISR Orbit: ', strstr(misr_orbit), FORMAT = fmt1
      PRINTF, log_unit, 'MISR Block: ', strstr(misr_block), FORMAT = fmt1
      PRINTF, log_unit, 'Target Camera: ', target_camera, FORMAT = fmt1
      PRINTF, log_unit, 'Target Band: ', target_band, FORMAT = fmt1
      PRINTF, log_unit, 'Target Resolution: ', strstr(target_resol), $
         FORMAT = fmt1
      PRINTF, log_unit
      PRINTF, log_unit, 'Product analyzed: ', 'L1B2 unscaled radiance', $
         FORMAT = fmt1
      PRINTF, log_unit, 'Number of masks requested: ', strstr(n_masks), $
         FORMAT = fmt1
      PRINTF, log_unit
   ENDIF

   ;  Initialize the output positional parameter(s): n_sources refers to the
   ;  number (nominally 35, numbered from 0 to 34) of data channels that are
   ;  potential sources of information to set the missing values in the
   ;  target data channel:
   n_sources = n_chns - 1

   ;  Define the required output arrays implied by the value of the input
   ;  positional parameter n_masks:

   ;  Define the output land arrays, which are always used (the minimum valid
   ;  value of n_masks is 1):
   best_land_cams = STRARR(n_sources)
   best_land_bnds = STRARR(n_sources)
   best_land_npts = LONARR(n_sources)
   best_land_rsmds = FLTARR(n_sources)
   best_land_cors = FLTARR(n_sources)
   best_land_as = FLTARR(n_sources)
   best_land_bs = FLTARR(n_sources)
   best_land_chisqs = DBLARR(n_sources)
   best_land_probs = FLTARR(n_sources)

   ;  Define the output water arrays, used if n_masks is set to 2 or 3:
   IF (n_masks GT 1) THEN BEGIN
      best_water_cams = STRARR(n_sources)
      best_water_bnds = STRARR(n_sources)
      best_water_npts = LONARR(n_sources)
      best_water_rsmds = FLTARR(n_sources)
      best_water_cors = FLTARR(n_sources)
      best_water_as = FLTARR(n_sources)
      best_water_bs = FLTARR(n_sources)
      best_water_chisqs = DBLARR(n_sources)
      best_water_probs = FLTARR(n_sources)
   ENDIF

   ;  Define the output cloud arrays, used if n_masks is set to 3:
   IF (n_masks GT 2) THEN BEGIN
      best_cloud_cams = STRARR(n_sources)
      best_cloud_bnds = STRARR(n_sources)
      best_cloud_npts = LONARR(n_sources)
      best_cloud_rsmds = FLTARR(n_sources)
      best_cloud_cors = FLTARR(n_sources)
      best_cloud_as = FLTARR(n_sources)
      best_cloud_bs = FLTARR(n_sources)
      best_cloud_chisqs = DBLARR(n_sources)
      best_cloud_probs = FLTARR(n_sources)
   ENDIF

   ; Initialize the best Pearson correlation coefficient so far to 0.0:
   best_land_cors[*] = 0.0
   IF (n_masks GT 1) THEN best_water_cors[*] = 0.0
   IF (n_masks GT 2) THEN best_cloud_cors[*] = 0.0
   current_max_land_cc = -1.0
   IF (n_masks GT 1) THEN current_max_water_cc = -1.0
   IF (n_masks GT 2) THEN current_max_cloud_cc = -1.0

   ;  Initialize the counter (0 to 34) that identifies the current camera and
   ;  spectral band considered as a potential source:
   iter = 0

   ;  Initialize the minimum and maximum indicators for the target and sources
   ;  in order to optimally set the plotting ranges:
   idx_val = WHERE(target_databuf GT 0.0, count_val)
   IF (count_val GT 0) THEN BEGIN
      min_target = MIN(target_databuf[idx_val])
      max_target = MAX(target_databuf)
   ENDIF
   min_source = 1000.0
   max_source = -1000.0
   best_kdx_lnd = -1
   best_kdx_wat = -1
   best_kdx_cld = -1

   ;  Iterate over the cameras, in their native order:
   FOR cam = 0, n_cams - 1 DO BEGIN
      source_camera = misr_cams[cam]

   ;  Iterate over the spectral bands, in their native order:
      FOR bnd = 0, n_bnds - 1 DO BEGIN
         source_band = misr_bnds[bnd]

   ;  Skip the source camera and band combination corresponding to the target
   ;  data channel:
         IF ((source_camera EQ target_camera) AND $
            (source_band EQ target_band)) THEN BEGIN
            CONTINUE
         ENDIF ELSE BEGIN

   ;  Retrieve the source Radiance data buffer:
         source_databuf = *rad_ptr[cam, bnd]

   ;  Retrieve the source RDQI data buffer:
         source_databuf_rd = *rdqi_ptr[cam, bnd]

   ;  Set the resolution of the source data channel:
         source_resol = 275
         IF (misr_mode EQ 'GM') THEN BEGIN
            IF ((source_camera NE 'AN') AND (source_band NE 'Red')) THEN $
               source_resol = 1100
         ENDIF

   ;  Retrieve the applicable mask for the source camera and band, and generate
   ;  the source land, and optionally water and cloud masks:
         source_mask = *lwc_mask_ptr[cam, bnd]
         IF (source_resol EQ 275) THEN $
            source_land_mask = BYTARR(2048, 512) $
            ELSE source_land_mask = BYTARR(512, 128)
         sldx = WHERE(source_mask EQ 1B, count_sl)
         IF (count_sl GT 0) THEN source_land_mask[sldx] = 1B

         IF (n_masks GT 1) THEN BEGIN
            IF (source_resol EQ 275) THEN $
               source_water_mask = BYTARR(2048, 512) $
               ELSE source_water_mask = BYTARR(512, 128)
            swdx = WHERE(source_mask EQ 2B, count_sw)
            IF (count_sw GT 0) THEN source_water_mask[swdx] = 2B
         ENDIF

         IF (n_masks GT 2) THEN BEGIN
            IF (source_resol EQ 275) THEN $
               source_cloud_mask = BYTARR(2048, 512) $
               ELSE source_cloud_mask = BYTARR(512, 128)
            scdx = WHERE(source_mask EQ 3B, count_sc)
            IF (count_sc GT 0) THEN source_cloud_mask[scdx] = 3B
         ENDIF

   ;  Save the camera and band names for the current iteration:
            best_land_cams[iter] = source_camera
            best_land_bnds[iter] = source_band

            IF (n_masks GT 1) THEN best_water_cams[iter] = source_camera
            IF (n_masks GT 1) THEN best_water_bnds[iter] = source_band

            IF (n_masks GT 2) THEN best_cloud_cams[iter] = source_camera
            IF (n_masks GT 2) THEN best_cloud_bnds[iter] = source_band
         ENDELSE

   ;  Update the minimum and maximum valid values for the sources:
         idx_val = WHERE(source_databuf GT 0.0, count_val)
         IF (count_val GT 0) THEN BEGIN
            IF (min_source GT MIN(source_databuf[idx_val])) THEN $
               min_source = MIN(source_databuf[idx_val])
            IF (max_source LT MAX(source_databuf[idx_val])) THEN $
               max_source = MAX(source_databuf[idx_val])
         ENDIF

   ;  Ensure that the spatial resolutions of the target and the source data
   ;  channels match, and if not, adjust the spatial resolution of the source
   ;  data channel:
         IF ((target_resol EQ 1100) AND (source_resol EQ 275)) THEN BEGIN
            source_databuf = hr2lr(source_databuf, 'Rad')
            source_databuf_rd = hr2lr(source_databuf_rd, 'RDQI')
            source_land_mask = hr2lr(source_land_mask, 'Mask')
            IF (n_masks GT 1) THEN $
               source_water_mask = hr2lr(source_water_mask, 'Mask')
            IF (n_masks GT 2) THEN $
               source_cloud_mask = hr2lr(source_cloud_mask, 'Mask')
         ENDIF
         IF ((target_resol EQ 275) AND (source_resol EQ 1100)) THEN BEGIN
            source_databuf = lr2hr(source_databuf)
            source_databuf_rd = lr2hr(source_databuf_rd)
            source_land_mask = lr2hr(source_land_mask)
            IF (n_masks GT 1) THEN source_water_mask = lr2hr(source_water_mask)
            IF (n_masks GT 2) THEN source_cloud_mask = lr2hr(source_cloud_mask)
         ENDIF
         IF (debug AND (SIZE(source_databuf, /N_ELEMENTS) NE $
            SIZE(target_databuf, /N_ELEMENTS))) THEN BEGIN
            error_code = 500
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Target databuf contains ' + $
               strstr(SIZE(target_databuf, /N_ELEMENTS)) + $
               ' elements but source target contains ' + $
               strstr(SIZE(source_databuf, /N_ELEMENTS)) + $
               ' elements.'
            RETURN, error_code
         ENDIF

   ;  Locate the land pixels with valid (Radiance > 0.0 and RDQI < 2B) values
   ;  in both the source and the target data channels. This code section assumes
   ;  that valid MISR observations over land result in strictly positive
   ;  reflectances, that valid RDQI values are 0 (good) and 1 (fair), and
   ;  that the target and source masks are set to 1B over land masses:
         kdx_lnd = WHERE((source_databuf[*, *] GT 0.0) AND $
            (source_databuf_rd[*, *] LT 2B) AND $
            (target_databuf[*, *] GT 0.0) AND $
            (target_databuf_rd[*, *] LT 2B) AND $
            (target_land_mask EQ 1B) AND $
            (source_land_mask EQ 1B), n_lnd_pts)
         best_land_npts[iter] = n_lnd_pts

   ;  Locate the water pixels with valid (Radiance > 0.0 and RDQI < 2B) values
   ;  in both the source and the target data channels. This code section assumes
   ;  that valid MISR observations over water result in strictly positive
   ;  reflectances, that valid RDQI values are 0 (good) and 1 (fair), and
   ;  that the target and source masks are set to 2B over water bodies:
         IF (n_masks GT 1) THEN BEGIN
            kdx_wat = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2B) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2B) AND $
               (target_water_mask EQ 2B) AND $
               (source_water_mask EQ 2B), n_wat_pts)
            best_water_npts[iter] = n_wat_pts
         ENDIF

   ;  Locate the cloud pixels with valid (Radiance > 0.0 and RDQI < 2B) values
   ;  in both the source and the target data channels. This code section assumes
   ;  that valid MISR observations over clouds result in strictly positive
   ;  reflectances, that valid RDQI values are 0 (good) and 1 (fair), and
   ;  that the target and source masks are set to 3B over cloud fields:
         IF (n_masks EQ 3) THEN BEGIN
            kdx_cld = WHERE((source_databuf[*, *] GT 0.0) AND $
               (source_databuf_rd[*, *] LT 2B) AND $
               (target_databuf[*, *] GT 0.0) AND $
               (target_databuf_rd[*, *] LT 2B) AND $
               (target_cloud_mask EQ 3B) AND $
               (source_cloud_mask EQ 3B), n_cld_pts)
            best_cloud_npts[iter] = n_cld_pts
         ENDIF

   ;  Compute the statistical fits as requested, if there are at least 10
   ;  valid pixels shared between the target and the source:

   ;  === Statistics for land masses, computed in all cases ===

         IF (n_lnd_pts GT 10) THEN BEGIN

   ;  Extract the land values wherever the source and the target are both
   ;  valid and available:
            source_lnd_data = source_databuf[kdx_lnd]
            target_lnd_data = target_databuf[kdx_lnd]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target land values wherever they are both valid and available:
            numer = TOTAL((source_lnd_data - target_lnd_data) * $
               (source_lnd_data - target_lnd_data))
            rmsd = SQRT(numer / n_lnd_pts)
            best_land_rsmds[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  land values wherever they are both valid and available:
            cc = CORRELATE(source_lnd_data, target_lnd_data, /DOUBLE)
            cc_lnd = FLOAT(cc)
            best_land_cors[iter] = cc_lnd

   ;  If this correlation coefficient is larger than the previous best result,
   ;  and scatterplots have been requested, save the current best source
   ;  databuf for subsequent plotting against the target databuf:
            IF (scatt_it AND $
               (cc_lnd GT current_max_land_cc)) THEN BEGIN
               current_max_land_cc = cc_lnd
               best_source_land_databuf = source_databuf
               best_kdx_lnd = kdx_lnd
            ENDIF

   ;  Compute the linear fit equation to estimate the target from the source
   ;  land values wherever they are both valid and available:
            res = LINFIT(source_lnd_data, target_lnd_data, CHISQR = chi, $
               PROB = prob, /DOUBLE)
            best_land_as[iter] = res[0]
            best_land_bs[iter] = res[1]
            best_land_chisqs[iter] = chi
            best_land_probs[iter] = prob

   ;  Consider the case where there are no common valid land pixel values:
         ENDIF ELSE BEGIN
            best_land_rsmds[iter] = -999.0
            best_land_cors[iter] = 0.0
            best_land_as[iter] = 0.0
            best_land_bs[iter] = 0.0
            best_land_chisqs[iter] = -999.0
            best_land_probs[iter] = 0.0
         ENDELSE

   ;  === Statistics for water bodies, computed only if n_masks > 1 ===

         IF (n_masks GE 2) THEN BEGIN
            IF (n_wat_pts GT 10) THEN BEGIN

   ;  Extract the water values wherever the source and the target are both
   ;  available:
               source_wat_data = source_databuf[kdx_wat]
               target_wat_data = target_databuf[kdx_wat]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target water values wherever they are both available:
               numer = TOTAL((source_wat_data - target_wat_data) * $
                  (source_wat_data - target_wat_data))
               rmsd = SQRT(numer / n_wat_pts)
               best_water_rsmds[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  water values wherever they are both available:
               cc = CORRELATE(source_wat_data, target_wat_data, /DOUBLE)
               cc_wat = FLOAT(cc)
               best_water_cors[iter] = cc_wat

   ;  If this correlation coefficient is larger than the previous best result,
   ;  and scatterplots have been requested, save the current best source
   ;  databuf for subsequent plotting against the target databuf:
               IF (scatt_it AND $
                  (cc_wat GT current_max_water_cc)) THEN BEGIN
                  current_max_water_cc = cc_wat
                  best_source_water_databuf = source_databuf
                  best_kdx_wat = kdx_wat
               ENDIF

   ;  Compute the linear fit equation to estimate the target from the source
   ;  water values wherever they are both available:
               res = LINFIT(source_wat_data, target_wat_data, CHISQR = chi, $
                  PROB = prob, /DOUBLE)
               best_water_as[iter] = res[0]
               best_water_bs[iter] = res[1]
               best_water_chisqs[iter] = chi
               best_water_probs[iter] = prob

   ;  Consider the case where there are no common valid water pixel values:
            ENDIF ELSE BEGIN
               best_water_rsmds[iter] = -999.0
               best_water_cors[iter] = 0.0
               best_water_as[iter] = 0.0
               best_water_bs[iter] = 0.0
               best_water_chisqs[iter] = -999.0
               best_water_probs[iter] = 0.0
            ENDELSE
         ENDIF

   ;  === Statistics for cloud fields, computed only if n_masks > 2 ===

         IF (n_masks EQ 3) THEN BEGIN
            IF (n_cld_pts GT 10) THEN BEGIN

   ;  Extract the cloud values wherever the source and the target are both
   ;  available:
               source_cld_data = source_databuf[kdx_cld]
               target_cld_data = target_databuf[kdx_cld]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target cloud values wherever they are both available:
               numer = TOTAL((source_cld_data - target_cld_data) * $
                  (source_cld_data - target_cld_data))
               rmsd = SQRT(numer / n_cld_pts)
               best_cloud_rsmds[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  cloud values wherever they are both available:
               cc = CORRELATE(source_cld_data, target_cld_data, /DOUBLE)
               cc_cld = FLOAT(cc)
               best_cloud_cors[iter] = cc_cld

   ;  If this correlation coefficient is larger than the previous best result,
   ;  and scatterplots have been requested, save the current best source
   ;  databuf for subsequent plotting against the target databuf:
               IF (scatt_it AND $
                  (cc_cld GT current_max_cloud_cc)) THEN BEGIN
                  current_max_cloud_cc = cc_cld
                  best_source_cloud_databuf = source_databuf
                  best_kdx_cld = kdx_cld
               ENDIF

   ;  Compute the linear fit equation to estimate the target from the source
   ;  cloud values wherever they are both available:
               res = LINFIT(source_cld_data, target_cld_data, CHISQR = chi, $
                  PROB = prob, /DOUBLE)
               best_cloud_as[iter] = res[0]
               best_cloud_bs[iter] = res[1]
               best_cloud_chisqs[iter] = chi
               best_cloud_probs[iter] = prob

   ;  Consider the case where there are no common valid cloud pixel values:
            ENDIF ELSE BEGIN
               best_cloud_rsmds[iter] = -999.0
               best_cloud_cors[iter] = 0.0
               best_cloud_as[iter] = 0.0
               best_cloud_bs[iter] = 0.0
               best_cloud_chisqs[iter] = -999.0
               best_cloud_probs[iter] = 0.0
            ENDELSE
         ENDIF

         iter = iter + 1

      ENDFOR
   ENDFOR

   ;  Sort the Pearson correlation coefficient arrays in descending order:
   idx_lnd_sorted = REVERSE(SORT(best_land_cors))
   IF (n_masks GE 2) THEN idx_wat_sorted = REVERSE(SORT(best_water_cors))
   IF (n_masks EQ 3) THEN idx_cld_sorted = REVERSE(SORT(best_cloud_cors))

   ;  Reorder the contents of the output structure arrays to rank them in order
   ;  of decreasing correlation coefficient:
   best_land_cams = best_land_cams[idx_lnd_sorted]
   best_land_bnds = best_land_bnds[idx_lnd_sorted]
   best_land_npts = best_land_npts[idx_lnd_sorted]
   best_land_rsmds = best_land_rsmds[idx_lnd_sorted]
   best_land_cors = best_land_cors[idx_lnd_sorted]
   best_land_as = best_land_as[idx_lnd_sorted]
   best_land_bs = best_land_bs[idx_lnd_sorted]
   best_land_chisqs = best_land_chisqs[idx_lnd_sorted]
   best_land_probs = best_land_probs[idx_lnd_sorted]

   IF (n_masks GE 2) THEN BEGIN
      best_water_cams = best_water_cams[idx_wat_sorted]
      best_water_bnds = best_water_bnds[idx_wat_sorted]
      best_water_npts = best_water_npts[idx_wat_sorted]
      best_water_rsmds = best_water_rsmds[idx_wat_sorted]
      best_water_cors = best_water_cors[idx_wat_sorted]
      best_water_as = best_water_as[idx_wat_sorted]
      best_water_bs = best_water_bs[idx_wat_sorted]
      best_water_chisqs = best_water_chisqs[idx_wat_sorted]
      best_water_probs = best_water_probs[idx_wat_sorted]
   ENDIF

   IF (n_masks EQ 3) THEN BEGIN
      best_cloud_cams = best_cloud_cams[idx_cld_sorted]
      best_cloud_bnds = best_cloud_bnds[idx_cld_sorted]
      best_cloud_npts = best_cloud_npts[idx_cld_sorted]
      best_cloud_rsmds = best_cloud_rsmds[idx_cld_sorted]
      best_cloud_cors = best_cloud_cors[idx_cld_sorted]
      best_cloud_as = best_cloud_as[idx_cld_sorted]
      best_cloud_bs = best_cloud_bs[idx_cld_sorted]
      best_cloud_chisqs = best_cloud_chisqs[idx_cld_sorted]
      best_cloud_probs = best_cloud_probs[idx_cld_sorted]
   ENDIF

   ;  Define the output structure to contain all required results:
   title = 'Best fits results'
   best_fits = CREATE_STRUCT('Title', title)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandCameras', best_land_cams)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandBands', best_land_bnds)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandNpts', best_land_npts)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandRMSDs', best_land_rsmds)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandCors', best_land_cors)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandAs', best_land_as)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandBs', best_land_bs)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandChisqs', best_land_chisqs)
   best_fits = CREATE_STRUCT(best_fits, 'BestLandProbs', best_land_probs)

   IF (n_masks GT 1) THEN BEGIN
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterCameras', best_water_cams)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterBands', best_water_bnds)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterNpts', best_water_npts)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterRMSDs', best_water_rsmds)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterCors', best_water_cors)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterAs', best_water_as)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterBs', best_water_bs)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterChisqs', best_water_chisqs)
      best_fits = CREATE_STRUCT(best_fits, 'BestWaterProbs', best_water_probs)
   ENDIF

   IF (n_masks GT 2) THEN BEGIN
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudCameras', best_cloud_cams)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudBands', best_cloud_bnds)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudNpts', best_cloud_npts)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudRMSDs', best_cloud_rsmds)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudCors', best_cloud_cors)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudAs', best_cloud_as)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudBs', best_cloud_bs)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudChisqs', best_cloud_chisqs)
      best_fits = CREATE_STRUCT(best_fits, 'BestCloudProbs', best_cloud_probs)
   ENDIF

   ;  Generate and save the scatterplots for the best land, ocean and cloud
   ;  fits, if requested and if data are available for these target types:
   IF (scatt_it) THEN BEGIN

   ;  === Scatterplots for land masses ===

      IF ((best_land_npts[0] GT 0) AND (best_kdx_lnd NE [-1])) THEN BEGIN

   ;  Set the title of the scatterplot:
         CASE n_masks OF
            1: title_lnd = 'Scatterplot for the best linear fit over Block'
            2: title_lnd = 'Scatterplot for the best linear fit over land'
            3: title_lnd = 'Scatterplot for the best linear fit over clear land'
         ENDCASE

   ;  Set the title of the X axis for the best land source data channel:
         source_title_lnd = 'L1B2 Radiance ' + mpob_str_space + $
            ' ' + best_land_cams[0] + ' ' + best_land_bnds[0] + $
            ' [$W m^{-2} sr^{-1} \mu m^{-1}$]'

   ;  Set the title of the Y axis for the land target data channel:
         target_title_lnd = 'L1B2 Radiance ' + mpob_str_space + $
            ' ' + target_camera  + ' ' + target_band + $
            ' [$W m^{-2} sr^{-1} \mu m^{-1}$]'

         CASE n_masks OF
            1: prefix_lnd = 'Bestfit_Nm' + strstr(n_masks) + '_All_'
            2: prefix_lnd = 'Bestfit_Nm' + strstr(n_masks) + '_Land_'
            3: prefix_lnd = 'Bestfit_Nm' + strstr(n_masks) + '_ClearLand_'
         ENDCASE

   ;  Generate the scatterplot:
         rc = plt_scatt_gen(best_source_land_databuf[best_kdx_lnd], $
            source_title_lnd, $
            target_databuf[best_kdx_lnd], $
            target_title_lnd, $
            title_lnd, $
            mpob_str, $
            mpobcb_str, $
            NPTS = best_land_npts[0], $
            RMSD = best_land_rsmds[0], $
            CORRCOEFF = best_land_cors[0], $
            LIN_COEFF_A = best_land_as[0], $
            LIN_COEFF_B = best_land_bs[0], $
            CHISQR = best_land_chisqs[0], $
            PROB = best_land_probs[0], $
            SET_MIN_SCATT = set_min_scatt, $
            SET_MAX_SCATT = set_max_scatt, $
            SCATT_PATH = scatt_fpath, $
            PREFIX = prefix_lnd, $
            VERBOSE = verbose, $
            DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         IF (debug AND (rc NE 0)) THEN BEGIN
            error_code = 510
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF ELSE BEGIN
         IF (verbose GT 2) THEN BEGIN
            PRINT, 'Scatterplot for land masses not generated: ' + $
               'no valid common data.'
            PRINT, 'best_land_npts[0] = ' + strstr(best_land_npts[0]) + $
               ' and best_kdx_lnd = ' + strstr(best_kdx_lnd)
         ENDIF
      ENDELSE

   ;  === Scatterplots for water bodies ===

      IF (n_masks GE 2) THEN BEGIN
         IF ((best_water_npts[0] GT 0) AND (best_kdx_wat NE [-1])) THEN BEGIN

   ;  Set the title of the scatterplot:
            CASE n_masks OF
               2: title_wat = 'Scatterplot for the best linear fit over water'
               3: title_wat = 'Scatterplot for the best linear fit over ' + $
                  'clear water'
               ELSE: BREAK
            ENDCASE

   ;  Set the title of the X axis for the best water source data channel:
            source_title_wat = 'L1B2 Radiance ' + mpob_str_space + $
               ' ' + best_water_cams[0] + ' ' + best_water_bnds[0] + $
               ' [$W m^{-2} sr^{-1} \mu m^{-1}$]'

   ;  Set the title of the Y axis for the water target data channel:
            target_title_wat = 'L1B2 Radiance ' + mpob_str_space + $
               ' ' + target_camera  + ' ' + target_band + $
               ' [$W m^{-2} sr^{-1} \mu m^{-1}$]'

            CASE n_masks OF
               2: prefix_wat = 'Bestfit_Nm' + strstr(n_masks) + '_Water_'
               3: prefix_wat = 'Bestfit_Nm' + strstr(n_masks) + '_ClearWater_'
               ELSE: BREAK
            ENDCASE

   ;  Generate the scatterplot:
            rc = plt_scatt_gen(best_source_water_databuf[best_kdx_wat], $
               source_title_wat, $
               target_databuf[best_kdx_wat], $
               target_title_wat, $
               title_wat, $
               mpob_str, $
               mpobcb_str, $
               NPTS = best_water_npts[0], $
               RMSD = best_water_rsmds[0], $
               CORRCOEFF = best_water_cors[0], $
               LIN_COEFF_A = best_water_as[0], $
               LIN_COEFF_B = best_water_bs[0], $
               CHISQR = best_water_chisqs[0], $
               PROB = best_water_probs[0], $
               SET_MIN_SCATT = set_min_scatt, $
               SET_MAX_SCATT = set_max_scatt, $
               SCATT_PATH = scatt_fpath, $
               PREFIX = prefix_wat, $
               VERBOSE = verbose, $
               DEBUG = debug, $
               EXCPT_COND = excpt_cond)
            IF (debug AND (rc NE 0)) THEN BEGIN
               error_code = 520
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDIF ELSE BEGIN
            IF (verbose GT 2) THEN BEGIN
               PRINT, 'Scatterplot for water bodies not generated: ' + $
                  'no valid common data.'
               PRINT, 'best_water_npts[0] = ' + strstr(best_water_npts[0]) + $
                  ' and best_kdx_wat = ' + strstr(best_kdx_wat)
            ENDIF
         ENDELSE
      ENDIF

   ;  === Scatterplots for cloud fields ===

      IF (n_masks EQ 3) THEN BEGIN
         IF ((best_cloud_npts[0] GT 0) AND (best_kdx_cld NE [-1])) THEN BEGIN

   ;  Set the title of the scatterplot:
            title_cld = 'Scatterplot for the best linear fit over clouds'

   ;  Set the title of the X axis for the best cloud source data channel:
            source_title_cld = 'L1B2 Radiance ' + mpob_str_space + $
               ' ' + best_cloud_cams[0] + ' ' + best_cloud_bnds[0] + $
               ' [$W m^{-2} sr^{-1} \mu m^{-1}$]'

   ;  Set the title of the Y axis for the cloud target data channel:
            target_title_cld = 'L1B2 Radiance ' + mpob_str_space + $
               ' ' + target_camera  + ' ' + target_band + $
               ' [$W m^{-2} sr^{-1} \mu m^{-1}$]'

            prefix_cld = 'Bestfit_Nm' + strstr(n_masks) + '_Cloud_'

   ;  Generate the scatterplot:
            rc = plt_scatt_gen(best_source_cloud_databuf[best_kdx_cld], $
               source_title_cld, $
               target_databuf[best_kdx_cld], $
               target_title_cld, $
               title_cld, $
               mpob_str, $
               mpobcb_str, $
               NPTS = best_cloud_npts[0], $
               RMSD = best_cloud_rsmds[0], $
               CORRCOEFF = best_cloud_cors[0], $
               LIN_COEFF_A = best_cloud_as[0], $
               LIN_COEFF_B = best_cloud_bs[0], $
               CHISQR = best_cloud_chisqs[0], $
               PROB = best_cloud_probs[0], $
               SET_MIN_SCATT = set_min_scatt, $
               SET_MAX_SCATT = set_max_scatt, $
               SCATT_PATH = scatt_fpath, $
               PREFIX = prefix_cld, $
               VERBOSE = verbose, $
               DEBUG = debug, $
               EXCPT_COND = excpt_cond)
            IF (debug AND (rc NE 0)) THEN BEGIN
               error_code = 530
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF
         ENDIF ELSE BEGIN
            IF (verbose GT 2) THEN BEGIN
               PRINT, 'Scatterplot for cloud fields not generated: ' + $
                  'no valid common data.'
               PRINT, 'best_cloud_npts[0] = ' + strstr(best_cloud_npts[0]) + $
                  ' and best_kdx_cld = ' + strstr(best_kdx_cld)
            ENDIF
         ENDELSE
      ENDIF
   ENDIF

   IF (log_it) THEN BEGIN

;  === Log results for land masses ===

      CASE n_masks OF
         1: PRINTF, log_unit, 'Results for all pixels, in ' + $
            'decreasing order of correlation coefficient:'
         2: PRINTF, log_unit, 'Results for land pixels, in ' + $
            'decreasing order of correlation coefficient:'
         3: PRINTF, log_unit, 'Results for clear land pixels, in ' + $
            'decreasing order of correlation coefficient:'
      ENDCASE
      PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
         'a', 'b', 'Chi sq', 'Proba', FORMAT = fmt2
      PRINTF, log_unit, strrepeat('=', 107)
      FOR il = 0, N_ELEMENTS(best_land_cams) - 1 DO BEGIN
         PRINTF, log_unit, $
            best_land_cams[il], $
            best_land_bnds[il], $
            best_land_npts[il], $
            best_land_rsmds[il], $
            best_land_cors[il], $
            best_land_as[il], $
            best_land_bs[il], $
            best_land_chisqs[il], $
            best_land_probs[il], $
            FORMAT = fmt3
      ENDFOR
      PRINTF, log_unit

   ;  === Log results for water bodies areas ===

      CASE n_masks OF
         2: PRINTF, log_unit, 'Results for water pixels, in ' + $
            'decreasing order of correlation coefficient:'
         3: PRINTF, log_unit, 'Results for clear water pixels, in ' + $
            'decreasing order of correlation coefficient:'
         ELSE: BREAK
      ENDCASE
      IF (n_masks GE 2) THEN BEGIN
         PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
            'a', 'b', 'Chi sq', 'Proba', FORMAT = fmt2
         PRINTF, log_unit, strrepeat('=', 107)
         FOR iw = 0, N_ELEMENTS(best_water_cams) - 1 DO BEGIN
            PRINTF, log_unit, $
               best_water_cams[iw], $
               best_water_bnds[iw], $
               best_water_npts[iw], $
               best_water_rsmds[iw], $
               best_water_cors[iw], $
               best_water_as[iw], $
               best_water_bs[iw], $
               best_water_chisqs[iw], $
               best_water_probs[iw], $
               FORMAT = fmt3
         ENDFOR
         PRINTF, log_unit
      ENDIF

   ;  === Log results for cloud areas ===

      IF (n_masks EQ 3) THEN BEGIN
         PRINTF, log_unit, 'Results for cloud pixels, in ' + $
            'decreasing order of correlation coefficient:'
         PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
            'a', 'b', 'Chi sq', 'Proba', FORMAT = fmt2
         PRINTF, log_unit, strrepeat('=', 107)
         FOR ic = 0, N_ELEMENTS(best_cloud_cams) - 1 DO BEGIN
            PRINTF, log_unit, $
               best_cloud_cams[ic], $
               best_cloud_bnds[ic], $
               best_cloud_npts[ic], $
               best_cloud_rsmds[ic], $
               best_cloud_cors[ic], $
               best_cloud_as[ic], $
               best_cloud_bs[ic], $
               best_cloud_chisqs[ic], $
               best_cloud_probs[ic], $
               FORMAT = fmt3
         ENDFOR
      ENDIF

      PRINTF, log_unit
      CLOSE, log_unit
      FREE_LUN, log_unit
      IF (verbose GT 0) THEN PRINT, 'The log file has been saved in ' + $
         log_fspec
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
