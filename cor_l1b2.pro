FUNCTION cor_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function saves the results of the computation of the
   ;  cross-correlation statistics between the 36 data channels of the 9
   ;  MISR L1B2 Georectified Radiance Product (GRP) Terrain-Projected Top
   ;  of Atmosphere (ToA) files, in the specified MISR MODE, for a single
   ;  MISR PATH, ORBIT and BLOCK combination.
   ;
   ;  ALGORITHM: This function relies on the IDL function
   ;  cor_l1b2_block.pro to carry out the computations, and saves the
   ;  numerical results in an IDL SAVE file as well as in a plain text
   ;  file. If the input data are from GLOBAL MODE files, this function
   ;  also separately computes the correlations between the 12 high
   ;  spatial resolution BRF fields.
   ;
   ;  SYNTAX:
   ;  rc = cor_l1b2(misr_mode, misr_path, misr_orbit, misr_block, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. By default, this function generates and
   ;      saves 2 files in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_’ + [misr_mode] + ’/’:
   ;
   ;      -   1 plain text file containing the numerical results of the
   ;          correlation computations, named
   ;          corr_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_toabrf_[acquisition-date]_
   ;          [MISR-Version]_[creation-date].txt.
   ;
   ;      -   1 IDL SAVE file containing the numerical results of the
   ;          correlation computations, named
   ;          corr_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_toabrf_[acquisition-date]_
   ;          [MISR-Version]_[creation-date].sav.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output files may be inexistent, incomplete or
   ;      useless.
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
   ;  *   Error 140: Input argument misr_block is invalid.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      cor_l1b2_block.pro.
   ;
   ;  *   Error 310: An exception condition occurred in function
   ;      orbit2date.pro.
   ;
   ;  *   Error 400: An exception condition occurred in function
   ;      get_l1b2_files.pro.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      is_writable.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   get_l1b2_files.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   cor_l1b2_block.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: *** WARNING ***: Execution of this function can take a
   ;      significant amount of time (e.g., over an hour on MicMac).
   ;
   ;  EXAMPLES:
   ;
   ;      rc = cor_l1b2('GM', 168, 68050, 110, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;
   ;      generates 2 files in the folder
   ;      root_dirs[3] + '/P168_O068050_B110/L1B2_GM/':
   ;
   ;      corr_P168_O068050_B110_L1B2_GM_toabrf_2012-10-03_F03_0024_2018-01-26.txt
   ;      corr_P168_O068050_B110_L1B2_GM_toabrf_2012-10-03_F03_0024_2018-01-26.sav
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–03–15: Version 0.8 — Initial release under the name
   ;      cor_l1b2.
   ;
   ;  *   2017–07–21: Version 0.9 — Use current version of the correlation
   ;      routines; update documentation; change the function name to
   ;      cor_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Update the function to rely on
   ;      get_l1b2_gm_files.pro instead of chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–05–02: Version 1.2 — Merge this function with its twin
   ;      cor_l1b2_lm.pro and change the name to cor_l1b2.pro.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2018 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following
   ;      conditions:
   ;
   ;      The above copyright notice and this permission notice shall be
   ;      included in all copies or substantial portions of the Software.
   ;
   ;      THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
   ;      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   ;      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   ;      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com.
   ;Sec-Cod

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

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
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Identify the current computer:
   SPAWN, 'hostname -s', computer
   computer = computer[0]

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()
   IF ((debug) AND (root_dirs[0] EQ 'Unrecognized computer')) THEN BEGIN
      error_code = 199
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Unrecognized computer.'
      RETURN, error_code
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str

   ;  Locate the 9 MISR L1B2 input files corresponding to the specified Path
   ;  and Orbit numbers:
   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the operating system path to the directory where the output must
   ;  be saved:
   local_log_path = pob_str + '/L1B2_' + misr_mode+ '/'
   log_path = root_dirs[3] + local_log_path

   ;  Return to the calling routine with an error message if the output
   ;  directory 'log_path' is not writable, and create it if it does not
   ;  exist:
   rc = is_writable(log_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, log_path

   ;  Compute the correlation statistics:
   rc = cor_l1b2_block(l1b2_files, misr_mode, misr_path, misr_orbit, $
      misr_block, stats_lr, stats_hr, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Retrieve the version of the L1B2 files:
   status = MTK_FILE_VERSION(l1b2_files[0], misr_version)

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the names of the output files:
   log_prefix = 'Corr_'
   sav_prefix = 'Corr_'
   fncomm = pob_str + '_L1B2' + misr_mode+ '_toabrf_' + acquis_date + '_' + $
      misr_version + '_' + date
   log_fname = log_prefix + fncomm + '.txt'
   sav_fname = sav_prefix + fncomm + '.sav'
   log_fspec = log_path + log_fname
   sav_fspec = log_path + sav_fname

   descr = 'Cross-correlations between the 36 data channels ' + $
      'of MISR L1B2 (low and high res).'
   SAVE, stats_lr, stats_hr, DESCRIPTION = descr, FILENAME = sav_fspec
   PRINT, 'The results have been saved in the IDL SAVE file'
   PRINT, sav_fspec

   fmt1 = '(A30, A)'

   ;  Open the log file and save the statistical information:
   OPENW, log_unit, log_fspec, /GET_LUN
   PRINTF, log_unit, "File name: ", "'" + log_fname + "'", FORMAT = fmt1
   PRINTF, log_unit, "Folder name: ", $
      "root_dirs[3] + '" + local_log_path + "'", FORMAT = fmt1
   PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
   PRINTF, log_unit, 'Generated on: ', computer, FORMAT = fmt1
   PRINTF, log_unit, 'Saved on: ', date, FORMAT = fmt1
   PRINTF, log_unit

   PRINTF, log_unit, 'Date of MISR acquisition: ' + acquis_date
   PRINTF, log_unit

   PRINTF, log_unit, 'Content: Statistical results on'
   PRINTF, log_unit, '- the 630 (36x35/2) cross-correlations between'
   PRINTF, log_unit, '  the 36 low spatial resolution data channels'
   PRINTF, log_unit, '- the 66 (12x11/2) cross-correlations between'
   PRINTF, log_unit, '  the 12 high spatial resolution data channels'
   PRINTF, log_unit, '  of MISR L1B2 GRP Terrain-Projected ToA GM BRF for'
   PRINTF, log_unit, '  ' + pob_str
   PRINTF, log_unit

   ;  Save the correlation statistics for the low spatial resolution data
   ;  channels:
   PRINTF, log_unit
   PRINTF, log_unit, 'Low spatial resolution correlation results:'
   PRINTF, log_unit
   n_exp = N_ELEMENTS(stats_lr)
   FOR i = 0, n_exp - 1 DO BEGIN
      PRINTF, log_unit, 'Experiment: ', $
         strstr(stats_lr[i].experiment), FORMAT = fmt2
      PRINTF, log_unit, 'array_1_id: ', $
         strstr(stats_lr[i].array_1_id), FORMAT = fmt2
      PRINTF, log_unit, 'array_2_id: ', $
         strstr(stats_lr[i].array_2_id), FORMAT = fmt2
      PRINTF, log_unit, 'N_points: ', $
         strstr(stats_lr[i].N_points), FORMAT = fmt2
      PRINTF, log_unit, 'RMSD: ', $
         strstr(stats_lr[i].RMSD), FORMAT = fmt2
      PRINTF, log_unit, 'Pearson_cc: ', $
         strstr(stats_lr[i].Pearson_cc), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_cc: ', $
         strstr(stats_lr[i].Spearman_cc), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_sig: ', $
         strstr(stats_lr[i].Spearman_sig), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_D: ', $
         strstr(stats_lr[i].Spearman_D), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_PROBD: ', $
         strstr(stats_lr[i].Spearman_PROBD), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_ZD: ', $
         strstr(stats_lr[i].Spearman_ZD), FORMAT = fmt2
      PRINTF, log_unit, 'Linear_fit_1: ', $
         strstr(stats_lr[i].Linear_fit_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_a_1: ', $
         strstr(stats_lr[i].Linfit_a_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_b_1: ', $
         strstr(stats_lr[i].Linfit_b_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_CHISQR_1: ', $
         strstr(stats_lr[i].Linfit_CHISQR_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_PROB_1: ', $
         strstr(stats_lr[i].Linfit_PROB_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linear_fit_2: ', $
         strstr(stats_lr[i].Linear_fit_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_a_2: ', $
         strstr(stats_lr[i].Linfit_a_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_b_2: ', $
         strstr(stats_lr[i].Linfit_b_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_CHISQR_2: ', $
         strstr(stats_lr[i].Linfit_CHISQR_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_PROB_2: ', $
         strstr(stats_lr[i].Linfit_PROB_2), FORMAT = fmt2
      PRINTF, log_unit
   ENDFOR

   ;  Save the correlation statistics for the high spatial resolution data
   ;  channels:
   PRINTF, log_unit
   PRINTF, log_unit, 'High spatial resolution results:'
   PRINTF, log_unit
   n_exp = N_ELEMENTS(stats_hr)
   fmt2 = '(A32, A)'
   FOR i = 0, n_exp - 1 DO BEGIN
      PRINTF, log_unit, 'Experiment: ', $
         strstr(stats_hr[i].experiment), FORMAT = fmt2
      PRINTF, log_unit, 'array_1_id: ', $
         strstr(stats_hr[i].array_1_id), FORMAT = fmt2
      PRINTF, log_unit, 'array_2_id: ', $
         strstr(stats_hr[i].array_2_id), FORMAT = fmt2
      PRINTF, log_unit, 'N_points: ', $
         strstr(stats_hr[i].N_points), FORMAT = fmt2
      PRINTF, log_unit, 'RMSD: ', $
         strstr(stats_hr[i].RMSD), FORMAT = fmt2
      PRINTF, log_unit, 'Pearson_cc: ', $
         strstr(stats_hr[i].Pearson_cc), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_cc: ', $
         strstr(stats_hr[i].Spearman_cc), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_sig: ', $
         strstr(stats_hr[i].Spearman_sig), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_D: ', $
         strstr(stats_hr[i].Spearman_D), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_PROBD: ', $
         strstr(stats_hr[i].Spearman_PROBD), FORMAT = fmt2
      PRINTF, log_unit, 'Spearman_ZD: ', $
         strstr(stats_hr[i].Spearman_ZD), FORMAT = fmt2
      PRINTF, log_unit, 'Linear_fit_1: ', $
         strstr(stats_hr[i].Linear_fit_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_a_1: ', $
         strstr(stats_hr[i].Linfit_a_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_b_1: ', $
         strstr(stats_hr[i].Linfit_b_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_CHISQR_1: ', $
         strstr(stats_hr[i].Linfit_CHISQR_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_PROB_1: ', $
         strstr(stats_hr[i].Linfit_PROB_1), FORMAT = fmt2
      PRINTF, log_unit, 'Linear_fit_2: ', $
         strstr(stats_hr[i].Linear_fit_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_a_2: ', $
         strstr(stats_hr[i].Linfit_a_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_b_2: ', $
         strstr(stats_hr[i].Linfit_b_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_CHISQR_2: ', $
         strstr(stats_hr[i].Linfit_CHISQR_2), FORMAT = fmt2
      PRINTF, log_unit, 'Linfit_PROB_2: ', $
         strstr(stats_hr[i].Linfit_PROB_2), FORMAT = fmt2
      PRINTF, log_unit
   ENDFOR

   PRINT, 'The results have been written in the plain text file'
   PRINT, log_fspec

   FREE_LUN, log_unit
   CLOSE, log_unit

   RETURN, return_code

END
