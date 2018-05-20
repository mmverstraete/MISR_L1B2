FUNCTION cor_l1b2_block, l1b2_files, misr_mode, misr_path, $
   misr_orbit, misr_block, stats_lr, stats_hr, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the cross-correlation statistics
   ;  between the 36 data channels contained in the 9 MISR L1B2
   ;  Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) files for the given MODE, PATH, ORBIT and BLOCK
   ;  combination. item ALGORITHM: This function computes the 630
   ;  (36 × 35/2) cross-correlations between the input data channels at
   ;  the lowest available spatial resolution (1100 m for GM and 275 m for
   ;  LM) and the results are saved in the output structure stats_lr. If
   ;  the input arguments are for GM data, this function (1) relies on the
   ;  IDL function hr2lr.pro to downsize the 12 high spatial resolution
   ;  data channels of the specified input files to match the lower
   ;  spatial resolution of the remaining 24 data channels and (2) also
   ;  computes the 66 (12 × 11/2) cross-correlations between the high
   ;  spatial resolution data channels and those resuts are saved in the
   ;  output structure stats_hr. If the input arguments are for LM data,
   ;  this latter structure is empty. All statistical results are carried
   ;  out by the IDL function cor_arrays.pro.
   ;
   ;  SYNTAX: rc = cor_l1b2_block(l1b2_files, misr_mode, misr_path, $
   ;  misr_orbit, misr_block, stats_lr, stats_hr, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   l1b2_files {STRING array} [I]: The file specifications (path and
   ;      filename) of the 9 MISR L1B2 GRP ToA GM radiance files.
   ;
   ;  *   misr_mode {STRING} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  *   stats_lr {STRUCTURE} [O]: The cross-correlation statistics
   ;      between all 36 MISR BRF fields at low spatial resolution.
   ;
   ;  *   stats_hr {STRUCTURE} [O]: The cross-correlation statistics
   ;      between all 12 MISR BRF fields at high spatial resolution.
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
   ;      provided in the call. The output positional parameter stats_lr
   ;      contains the correlation statistics for the 36 data channels at
   ;      the lowest spatial resolution (1100 m for GM, 275 m for LM). For
   ;      GM input data, the output positional parameter stats_hr contains
   ;      the correlation statistics for the 12 data channels available at
   ;      the higher spatial resolution (275 m). In the case of LM data,
   ;      this second output structure is void.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters stats_lr and stats_hr
   ;      may be empty, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input argument misr_path is invalid.
   ;
   ;  *   Error 120: Input argument misr_orbit is invalid.
   ;
   ;  *   Error 130: Input argument misr_block is invalid.
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
   ;  *   Error 240: An exception condition occurred in function
   ;      acquis_date.pro.
   ;
   ;  *   Error 300: No or more than 1 file(s) found for the first low
   ;      resolution data channel.
   ;
   ;  *   Error 310: An exception condition occurred in function
   ;      MTK_READDATA while reading l1b2_file_1 low resolution.
   ;
   ;  *   Error 320: No or more than 1 file(s) found for the second low
   ;      resolution data channel.
   ;
   ;  *   Error 330: An exception condition occurred in function
   ;      MTK_READDATA while reading l1b2_file_2 low resolution.
   ;
   ;  *   Error 340: An exception condition occurred in function
   ;      cor_arrays.pro while computing correlations between the low
   ;      resolution channels.
   ;
   ;  *   Error 350: No or more than 1 file(s) found for the first high
   ;      resolution data channel.
   ;
   ;  *   Error 360: An exception condition occurred in function
   ;      MTK_READDATA while reading l1b2_file_1 high resolution.
   ;
   ;  *   Error 370: No or more than 1 file(s) found for the second high
   ;      resolution data channel.
   ;
   ;  *   Error 380: An exception condition occurred in function
   ;      MTK_READDATA while reading l1b2_file_2 high resolution.
   ;
   ;  *   Error 390: An exception condition occurred in function
   ;      cor_arrays.pro while computing correlations between the high
   ;      resolution channels.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   cor_arrays.pro
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   round_dec.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: *** WARNING ***: Execution of this function can take a
   ;      significant amount of time (e.g., over an hour on MicMac).
   ;
   ;  EXAMPLES:
   ;
   ;      rc = cor_l1b2_block(l1b2_files, 'GM', 168, 68050, 110, stats_lr, $
   ;         stats_hr, /DEBUG, EXCPT_COND = excpt_cond)
   ;
   ;      returns the statistical results in ouput arguments stats_lr and
   ;      stats_hr, in the folder root_dirs[3] + 'P168_O068050_B110/L1B2_GM/'.
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–02–28: Version 0.8 — Initial release under the name
   ;      cor_l1b2_block.
   ;
   ;  *   2017–07–21: Version 0.9 — Removed code to write a log file
   ;      (transferred to program cor_l1b2.pro, now called
   ;      cor_l1b2_gm.pro); add misr_path, misr_orbit, misr_block and the
   ;      MISR data acquisition date to the output structures; update the
   ;      documentation.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–04–08: Version 1.1 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–04–23: Version 1.2 — Improve the debugging tests.
   ;
   ;  *   2018–05–02: Version 1.3 — Merge this function with its twin
   ;      cor_l1b2_lm_block.pro and change the name to cor_l1b2_block.pro.
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
      n_reqs = 7
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): l1b2_files, misr_mode, misr_path, ' + $
            'misr_orbit, misr_block, stats_lr, stats_hr.'
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

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   misr_chns = misr_specs.ChannelNames
   n_chns = misr_specs.NChannels

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Management of status codes from calls to MISR Toolkit routines:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_SETREGION_BY_PATH_BLOCKRANGE = ' + strstr(status)
      RETURN, error_code
   ENDIF
   ;  Create a named structure to contain all results computed with the
   ;  2 low resolution fields ((36 x 35) / 2 = 1260 / 2 = 630):
   stats = CREATE_STRUCT(NAME = 'Bivariate', $
      'misr_mode', misr_mode, $
      'misr_path', misr_path, $
      'misr_orbit', misr_orbit, $
      'misr_block', misr_block, $
      'acquis_date', acquis_date, $
      'experiment', 0, $
      'array_1_id', '', $
      'array_2_id', '', $
      'N_points', 0L, $
      'RMSD', 0.0, $
      'Pearson_cc', 0.0, $
      'Spearman_cc', 0.0, $
      'Spearman_sig', 0.0, $
      'Spearman_D', 0.0, $
      'Spearman_PROBD', 0.0, $
      'Spearman_ZD', 0.0, $
      'Linear_fit_1', '', $
      'Linfit_a_1', 0.0, $
      'Linfit_b_1', 0.0, $
      'Linfit_CHISQR_1', 0.0, $
      'Linfit_PROB_1', 0.0, $
      'Linear_fit_2', '', $
      'Linfit_a_2', 0.0, $
      'Linfit_b_2', 0.0, $
      'Linfit_CHISQR_2', 0.0, $
      'Linfit_PROB_2', 0.0)
   stats_lr = REPLICATE(stats, 630)

   PRINT, 'Computing the correlation statistics for the 36 data ' + $
      'channels at the lowest spatial resolution (1100 m for GM, ' + $
      '275 m for LM):'

   ;  Iterate over the channels for the first field:
   n_iter = 0
   FOR i = 0, n_chns - 1 DO BEGIN

   ;  Identify the camera and band for the first field:
      cam_1 = STRMID(misr_chns[i], 0, 2)
      ban_1 = STRMID(misr_chns[i], 3)

   ;  Identify the file containing this data channel:
      idx = WHERE(STRPOS(l1b2_files, cam_1) GT 1, count)
      IF ((debug) AND (count NE 1)) THEN BEGIN
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': No or more than 1 file(s) found for first low ' + $
            'resolution data channel ' + strstr(i) + ' (from 0 to 35).'
         RETURN, error_code
      ENDIF
      l1b2_file_1 = l1b2_files[idx[0]]

   ;  Request the corresponding BRF field:
      grid_1 = ban_1 + 'Band'
      field_1 = ban_1 + ' Brf'

   ;  Read the data for this first channel:
      status = MTK_READDATA(l1b2_file_1, grid_1, field_1, region, buf_1, $
         mapinfo)
      IF ((debug) AND (status NE 0)) THEN BEGIN
         error_code = 310
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Error encountered in MTK_READDATA while reading ' + $
            l1b2_file_1
         RETURN, error_code
      ENDIF

   ;  If the data are for Global Mode and this is is a red channel, or a
   ;  channel of the AN camera, generate a low spatial resolution version
   ;  of the data:
      IF ((misr_mode EQ 'GM') AND ((ban_1 EQ 'Red') OR (cam_1 EQ 'AN'))) $
         THEN BEGIN
         buf_1 = hr2lr(buf_1)
      ENDIF

   ;  Iterate over the channels for the second field:
      FOR j = i + 1, n_chns - 1 DO BEGIN

   ;  Identify the camera and band for the second field:
         cam_2 = STRMID(misr_chns[j], 0, 2)
         ban_2 = STRMID(misr_chns[j], 3)

   ;  Identify the file containing this data channel:
         jdx = WHERE(STRPOS(l1b2_files, cam_2) GT 1, count)
         IF ((debug) AND (count NE 1)) THEN BEGIN
            error_code = 320
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': No or more than 1 file(s) found for second low ' + $
               'resolution data channel ' + strstr(i) + ' (from i+1 to 35).'
            RETURN, error_code
         ENDIF
         l1b2_file_2 = l1b2_files[jdx[0]]

   ;  Request the corresponding BRF field:
         grid_2 = ban_2 + 'Band'
         field_2 = ban_2 + ' Brf'

   ;  Read the data for this second channel:
         status = MTK_READDATA(l1b2_file_2, grid_2, field_2, region, buf_2, $
            mapinfo)
         IF ((debug) AND (status NE 0)) THEN BEGIN
            error_code = 330
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error encountered in MTK_READDATA while reading ' + $
               l1b2_file_2
            RETURN, error_code
         ENDIF

   ;  If the data are for Global Mode and this is is a red channel, or a
   ;  channel of the AN camera, generate a low spatial resolution version
   ;  of the data:
         IF ((misr_mode EQ 'GM') AND ((ban_2 EQ 'Red') OR (cam_2 EQ 'AN'))) THEN BEGIN
            buf_2 = hr2lr(buf_2)
         ENDIF

   ;  Locate the pixels with valid (> 0) values in both fields:
         kdx = WHERE((buf_1[*, *] GT 0.0) AND (buf_2[*, *] GT 0.0), n_pts)
         f_1 = buf_1[kdx]
         f_2 = buf_2[kdx]

   ;  Set the experiment metadata in the output structure:
         stats_lr[n_iter].experiment = n_iter
         stats_lr[n_iter].array_1_id = misr_chns[i]
         stats_lr[n_iter].array_2_id = misr_chns[j]

   ;  Compute the correlation statistics:
         rc = cor_arrays(f_1, f_2, stats, $
            DEBUG = debug, EXCPT_COND = excpt_cond)
         IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
            error_code = 340
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
               rout_name + ': ' + excpt_cond
            RETURN, error_code
         ENDIF

   ;  Save the results in the array of structures:
         stats_lr[n_iter].N_points = stats.N_points
         stats_lr[n_iter].RMSD = stats.RMSD
         stats_lr[n_iter].Pearson_cc = stats.Pearson_cc
         stats_lr[n_iter].Spearman_cc = stats.Spearman_cc
         stats_lr[n_iter].Spearman_sig = stats.Spearman_sig
         stats_lr[n_iter].Spearman_D = stats.Spearman_D
         stats_lr[n_iter].Spearman_PROBD = stats.Spearman_PROBD
         stats_lr[n_iter].Spearman_ZD = stats.Spearman_ZD
         stats_lr[n_iter].Linear_fit_1 = stats.Linear_fit_1
         stats_lr[n_iter].Linfit_a_1 = stats.Linfit_a_1
         stats_lr[n_iter].Linfit_b_1 = stats.Linfit_b_1
         stats_lr[n_iter].Linfit_CHISQR_1 = stats.Linfit_CHISQR_1
         stats_lr[n_iter].Linfit_PROB_1 = stats.Linfit_PROB_1
         stats_lr[n_iter].Linear_fit_2 = stats.Linear_fit_2
         stats_lr[n_iter].Linfit_a_2 = stats.Linfit_a_2
         stats_lr[n_iter].Linfit_b_2 = stats.Linfit_b_2
         stats_lr[n_iter].Linfit_CHISQR_2 = stats.Linfit_CHISQR_2
         stats_lr[n_iter].Linfit_PROB_2 = stats.Linfit_PROB_2

         n_iter = n_iter + 1
      ENDFOR

      PRINT, 'Done with data channel ' + misr_chns[i]
   ENDFOR

   ;  If processing Global Mode data, reset the list of data channels to the
   ;  restricted sequence of names of the 12 MISR high spatial resolution
   ;  data channels:
   IF (misr_mode EQ 'GM') THEN BEGIN
      misr_chns = ['DF_Red', 'CF_Red', 'BF_Red', 'AF_Red', 'AN_Blue', $
         'AN_Green', 'AN_Red', 'AN_NIR', 'AA_Red', 'BA_Red', 'CA_Red', 'DA_Red']
      n_chns = N_ELEMENTS(misr_chns)

   ;  Create a named structure to contain all results computed with the
   ;  2 high resolution fields ((12 x 11) / 2 = 132 / 2 = 66):
      stats_hr = REPLICATE(stats, 66)

      PRINT, 'Computing the correlation statistics for the 12 data ' + $
         'channels at the high spatial resolution for GM data:'

   ;  Iterate over the channels for the first field:
      n_iter = 0
      FOR i = 0, n_chns - 1 DO BEGIN

   ;  Identify the camera and band for the first field:
         cam_1 = STRMID(misr_chns[i], 0, 2)
         ban_1 = STRMID(misr_chns[i], 3)

   ;  Identify the file containing this channel:
         idx = WHERE(STRPOS(l1b2_files, cam_1) GT 1, count)
         IF (count NE 1) THEN BEGIN
            error_code = 350
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': No or more than 1 file(s) found for first high ' + $
               'resolution data channel ' + strstr(i) + ' (from 0 to 12).'
            RETURN, error_code
         ENDIF
         l1b2_file_1 = l1b2_files[idx[0]]

   ;  Request the corresponding BRF field:
         grid_1 = ban_1 + 'Band'
         field_1 = ban_1 + ' Brf'

   ;  Read the data for this first channel:
         status = MTK_READDATA(l1b2_file_1, grid_1, field_1, region, buf_1, $
            mapinfo)
         IF ((debug) AND (status NE 0)) THEN BEGIN
            error_code = 360
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error encountered in MTK_READDATA while reading ' + $
               l1b2_file_1
            RETURN, error_code
         ENDIF

   ;  Iterate over the channels for the second field:
         FOR j = i + 1, n_chns - 1 DO BEGIN

   ;  Identify the camera and band for the second field:
            cam_2 = STRMID(misr_chns[j], 0, 2)
            ban_2 = STRMID(misr_chns[j], 3)

   ;  Identify the file containing this channel:
            jdx = WHERE(STRPOS(l1b2_files, cam_2) GT 1, count)
            IF (count NE 1) THEN BEGIN
               error_code = 370
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': No or more than 1 file(s) found for ' + $
                  ' second high resolution data channel ' + strstr(i) + $
                  ' (from i+1 to 35).'
               RETURN, error_code
            ENDIF
            l1b2_file_2 = l1b2_files[jdx[0]]

   ;  Request the corresponding BRF field:
            grid_2 = ban_2 + 'Band'
            field_2 = ban_2 + ' Brf'

   ;  Read the data for this second channel:
            status = MTK_READDATA(l1b2_file_2, grid_2, field_2, region, $
               buf_2, mapinfo)
            IF ((debug) AND (status NE 0)) THEN BEGIN
               error_code = 380
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Error encountered in MTK_READDATA ' + $
                  'while reading ' + l1b2_file_2
               RETURN, error_code
            ENDIF

   ;  Locate the pixels with valid values in both fields:
            kdx = WHERE((buf_1[*, *] GT 0.0) AND (buf_2[*, *] GT 0.0), n_pts)
            f_1 = buf_1[kdx]
            f_2 = buf_2[kdx]

   ;  Set the experiment metadata in the output structure:
            stats_hr[n_iter].experiment = n_iter
            stats_hr[n_iter].array_1_id = misr_chns[i]
            stats_hr[n_iter].array_2_id = misr_chns[j]

   ;  Compute the correlation statistics:
            rc = cor_arrays(f_1, f_2, stats, $
               DEBUG = debug, EXCPT_COND = excpt_cond)
            IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
               error_code = 390
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': ' + excpt_cond
               RETURN, error_code
            ENDIF

   ;  Save the results in the array of structures:
            stats_hr[n_iter].N_points = stats.N_points
            stats_hr[n_iter].RMSD = stats.RMSD
            stats_hr[n_iter].Pearson_cc = stats.Pearson_cc
            stats_hr[n_iter].Spearman_cc = stats.Spearman_cc
            stats_hr[n_iter].Spearman_sig = stats.Spearman_sig
            stats_hr[n_iter].Spearman_D = stats.Spearman_D
            stats_hr[n_iter].Spearman_PROBD = stats.Spearman_PROBD
            stats_hr[n_iter].Spearman_ZD = stats.Spearman_ZD
            stats_hr[n_iter].Linear_fit_1 = stats.Linear_fit_1
            stats_hr[n_iter].Linfit_a_1 = stats.Linfit_a_1
            stats_hr[n_iter].Linfit_b_1 = stats.Linfit_b_1
            stats_hr[n_iter].Linfit_CHISQR_1 = stats.Linfit_CHISQR_1
            stats_hr[n_iter].Linfit_PROB_1 = stats.Linfit_PROB_1
            stats_hr[n_iter].Linear_fit_2 = stats.Linear_fit_2
            stats_hr[n_iter].Linfit_a_2 = stats.Linfit_a_2
            stats_hr[n_iter].Linfit_b_2 = stats.Linfit_b_2
            stats_hr[n_iter].Linfit_CHISQR_2 = stats.Linfit_CHISQR_2
            stats_hr[n_iter].Linfit_PROB_2 = stats.Linfit_PROB_2

            n_iter = n_iter + 1
         ENDFOR

         PRINT, 'Done with data channel ' + misr_chns[i]
      ENDFOR
   ENDIF ELSE BEGIN
      stats_hr = {}
   ENDELSE

   RETURN, return_code

END
