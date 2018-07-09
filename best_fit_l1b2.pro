FUNCTION best_fit_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   misr_camera, misr_band, best_camera_oce, best_band_oce, best_npts_oce, $
   best_rmsd_oce, best_cor_oce, best_a_oce, best_b_oce, best_chisq_oce, $
   best_prob_oce, best_camera_lnd, best_band_lnd, best_npts_lnd, $
   best_rmsd_lnd, best_cor_lnd, best_a_lnd, best_b_lnd, best_chisq_lnd, $
   best_prob_lnd, AGP_VERSION = agp_version, VERBOSE = verbose, $
   SCATTERPLOT = scatterplot, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function determines the best linear fit formula to
   ;  estimate values in the target MISR L1B2 data channel specified by a
   ;  MODE, PATH, ORBIT, BLOCK, CAMERA and BAND, and optionally saves a
   ;  log file and a graphic scatterplot containing that information.
   ;
   ;  ALGORITHM: This function computes the linear fits between the
   ;  specified target data channel and the other 35 MISR data channels
   ;  for the same MODE, PATH, ORBIT and BLOCK, and returns the parameters
   ;  of the optimal linear function required to estimate values in the
   ;  target data channel as output positional parameters.
   ;
   ;  SYNTAX: best_fit_l1b2(misr_mode, misr_path, misr_orbit, $
   ;  misr_block, misr_camera, misr_band, best_camera_oce, $
   ;  best_band_oce, best_npts_oce, best_rmsd_oce, best_cor_oce, $
   ;  best_a_oce, best_b_oce, best_chisq_oce, best_prob_oce, $
   ;  best_camera_lnd, best_band_lnd, best_npts_lnd, best_rmsd_lnd, $
   ;  best_cor_lnd, best_a_lnd, best_b_lnd, best_chisq_lnd, $
   ;  best_prob_lnd, AGP_VERSION = agp_version, VERBOSE = verbose, $
   ;  SCATTERPLOT = scatterplot, DEBUG = debug, EXCPT_COND = excpt_cond)
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
   ;  *   misr_camera {STRING} [I]: The target MISR CAMERA name.
   ;
   ;  *   misr_band {STRING} [I]: The target MISR BAND name.
   ;
   ;  *   best_camera_oce {STRING} [O]: The name of the best MISR CAMERA
   ;      to estimate the values in the target data channel over deep
   ;      lakes and oceanic regions.
   ;
   ;  *   best_band_oce {STRING} [O]: The name of the best MISR BAND to
   ;      estimate the values in the target data channel over deep lakes
   ;      and oceanic regions.
   ;
   ;  *   best_npts_oce {LONG} [O]: The number of valid pixels common to
   ;      the target and the source data channels used to compute the
   ;      statistics over deep lakes and oceanic regions.
   ;
   ;  *   best_rmsd_oce {FLOAT} [O]: The root mean square value of the
   ;      differences between the best linear fit and the data over deep
   ;      lakes and oceanic regions.
   ;
   ;  *   best_cor_oce {FLOAT} [O]: The correlation coefficient between
   ;      the valid pixels common to the target and the source data
   ;      channels over deep lakes and oceanic regions.
   ;
   ;  *   best_a_oce {FLOAT} [O]: The coefficient a in the best linear fit
   ;      equation between the source and the target data channels over
   ;      deep lakes and oceanic regions.
   ;
   ;  *   best_b_oce {FLOAT} [O]: The coefficient b in the best linear fit
   ;      equation between the source and the target data channels over
   ;      deep lakes and oceanic regions.
   ;
   ;  *   best_chisq_oce {FLOAT} [O]: The value of the Chi square
   ;      statistics (minimmized to define the linear fit) over deep lakes
   ;      and oceanic regions.
   ;
   ;  *   best_prob_oce {FLOAT} [O]: The probability that the computed fit
   ;      would have a value of Chi square or greater over deep lakes and
   ;      oceanic regions.
   ;
   ;  *   best_camera_lnd {STRING} [O]: The name of the best MISR CAMERA
   ;      to estimate the values in the target data channel over
   ;      terrestrial regions.
   ;
   ;  *   best_band_lnd {STRING} [O]: The name of the best MISR BAND to
   ;      estimate the values in the target data channel over terrestrial
   ;      regions.
   ;
   ;  *   best_npts_lnd {LONG} [O]: The number of valid pixels common to
   ;      the target and the source data channels used to compute the
   ;      statistics over terrestrial regions.
   ;
   ;  *   best_rmsd_lnd {FLOAT} [O]: The root mean square value of the
   ;      differences between the best linear fit and the data over
   ;      terrestrial regions.
   ;
   ;  *   best_cor_oce {FLOAT} [O]: The correlation coefficient between
   ;      the valid pixels common to the target and the source data
   ;      channels over terrestrial regions.
   ;
   ;  *   best_a_oce {FLOAT} [O]: The coefficient a in the best linear fit
   ;      equation between the source and the target data channels over
   ;      terrestrial regions.
   ;
   ;  *   best_b_oce {FLOAT} [O]: The coefficient b in the best linear fit
   ;      equation between the source and the target data channels over
   ;      terrestrial regions.
   ;
   ;  *   best_chisq_oce {FLOAT} [O]: The value of the Chi square
   ;      statistics (minimmized to define the linear fit) over
   ;      terrestrial regions.
   ;
   ;  *   best_prob_oce {FLOAT} [O]: The probability that the computed fit
   ;      would have a value of Chi square or greater over terrestrial
   ;      regions.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   AGP_VERSION = agp_version {STRING} [I] (Default value: ’F01_24’):
   ;      The AGP version identifier to use.
   ;
   ;  *   VERBOSE = verbose {INT} [I]: Flag to output (1) or skip (0) the
   ;      details of the computations in a log file.
   ;
   ;  *   SCATTERPLOT = scatterplot {INT} [I] (Default value: 0): Flag to
   ;      generate (1) or skip (0) a scatterplot of the two best
   ;      correlated data channels.
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
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameters and the
   ;      optional output files contain the results generated by this
   ;      function.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters and eventual output
   ;      files may be undefined, inexistent, incomplete or useless.
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
   ;  *   Error 140: The input positional parameter misr_block is invalid.
   ;
   ;  *   Error 150: The input positional parameter misr_camera is
   ;      invalid.
   ;
   ;  *   Error 160: The input positional parameter misr_band is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in block2str.pro.
   ;
   ;  *   Error 240: An exception condition occurred in orbit2date.pro.
   ;
   ;  *   Error 250: An exception condition occurred in
   ;      make_agp_masks.pro.
   ;
   ;  *   Error 300: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 310: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading the target data channel.
   ;
   ;  *   Error 320: An exception condition occurred in fn2pocv_l1b2.pro.
   ;
   ;  *   Error 330: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA while reading one of the other data channels.
   ;
   ;  *   Error 340: Target and source databufs do not contain the same
   ;      number of elements.
   ;
   ;  *   Error 400: An exception condition occurred in
   ;      get_l1b2_files.pro.
   ;
   ;  *   Error 500: An exception condition occurred in plt_scatt_gen.pro
   ;      (ocean).
   ;
   ;  *   Error 510: An exception condition occurred in plt_scatt_gen.pro
   ;      (land).
   ;
   ;  *   Error 520: An exception condition occurred in is_writable.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_band.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_camera.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   fn2pocv_l1b2_gm.pro
   ;
   ;  *   get_l1b2_files.pro
   ;
   ;  *   hr2lr.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   lr2hr.pro
   ;
   ;  *   make_agp_masks.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   plt_scatt_gen.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function works equally well for GM and LM files.
   ;
   ;  *   NOTE 2: If the input positional parameter misr_mode is GM and if
   ;      the target is a low-resolution data channel, the 12
   ;      high-resolution data channels are downscaled with the function
   ;      hr2lr.pro before computing the best fit; conversely, if the
   ;      target is a high-resolution data channel, the 24 low-resolution
   ;      data channels are upscaled with the function lr2hr.pro before
   ;      computing the best fit.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 68050
   ;      IDL> misr_block = 111
   ;      IDL> misr_camera = 'AN'
   ;      IDL> misr_band = 'Blue'
   ;      IDL> misr_mode = 'LM'
   ;      IDL> rc = best_fit_l1b2(misr_path, misr_orbit, misr_block, $
   ;         misr_camera, misr_band, misr_mode, best_camera, best_band, $
   ;         best_a, best_b, best_chisq, best_prob, /VERBOSE, $
   ;         /SCATTERPLOT, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> Done with Camera AA and Band Blue
   ;           Done with Camera AA and Band Green
   ;           ...
   ;           Done with Camera DF and Band NIR
   ;      The scatterplot has been saved in
   ;         ~/MISR_HR/Outcomes/P168_O068050_B111/L1B2_LM/
   ;         Bestfit_L1B2 BRF LM P168 O068050 B111 AN Blue.png
   ;      The log file has been saved in
   ;         ~/MISR_HR/Outcomes/P168_O068050_B111/L1B2_LM/
   ;         Bestfit_L1B2 BRF LM P168 O068050 B111 AN Blue.txt
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + , excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0 and excpt_cond = ><
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–05–11: Version 0.9 — Initial release.
   ;
   ;  *   2017–05–12: Version 1.0 — Initial public release.
   ;
   ;  *   2018–05–18: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–06–14: Version 1.6 — Bug fix in setting the spatial
   ;      resolutions of the target and source data buffers.
   ;
   ;  *   2018–07–09: Version 1.7 — Update this routine to rely on the new
   ;      function
   ;      get_host_info.pro and the updated version of the function
   ;      set_root_dirs.pro.
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

   ;  If the AGP version number is not specified, use 'F01_24':
   IF (~KEYWORD_SET(agp_version)) THEN agp_version = 'F01_24'

   ;  Initialize the output positional parameter(s):
   best_camera_oce = ''
   best_band_oce = ''
   best_npts_oce = 0L
   best_rmsd_oce = 0.0
   best_cor_oce = 0.0
   best_a_oce = 0.0
   best_b_oce = 0.0
   best_chisq_oce = 0.0
   best_prob_oce = 0.0

   best_camera_lnd = ''
   best_band_lnd = ''
   best_npts_lnd = 0L
   best_rmsd_lnd = 0.0
   best_cor_lnd = 0.0
   best_a_lnd = 0.0
   best_b_lnd = 0.0
   best_chisq_lnd = 0.0
   best_prob_lnd = 0.0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 24
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_mode, misr_path, misr_orbit, ' + $
            'misr_block, misr_camera, misr_band, best_camera_oce, ' + $
            'best_band_oce, best_npts_oce, best_rmsd_oce, best_cor_oce, ' + $
            'best_a_oce, best_b_oce, best_chisq_oce, best_prob_oce, ' + $
            'best_camera_lnd, best_band_lnd, best_npts_lnd, ' + $
            'best_rmsd_lnd, best_cor_lnd, best_a_lnd, best_b_lnd, ' + $
            'best_chisq_lnd, best_prob_lnd.'
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

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_camera' is invalid:
      rc = chk_misr_camera(misr_camera, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_band' is invalid:
      rc = chk_misr_band(misr_band, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name)

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

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
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str
   pob_str_space = pob_str.Replace('_', ' ')

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      error_code = 240
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the resolution of the target data channel (a flag used later on to
   ;  downscale or upscale data fields as appropriate):
   target_resol = 275
   IF ((misr_mode EQ 'GM') AND (misr_camera NE 'AN')) THEN BEGIN
      IF (misr_band NE 'Red') THEN target_resol = 1100
   ENDIF

   ;  Generate the MISR AGP land cover masks for the 7 original classes at
   ;  the spatial resolution of the target data channel:
   rc = make_agp_masks(misr_path, misr_block, target_resol, masks, $
      AGP_VERSION = agp_version, /VERBOSE, /MAPIT, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 250
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate two main masks, one for shallow and deep ocean as well as deep
   ;  inland water, nominally labeled 'ocean', and the other for all other
   ;  classes, nominally labeled 'land', by combining individual masks:
   oce_msk = REFORM(masks[0, *, *]) OR $
      REFORM(masks[5, *, *]) OR $
      REFORM(masks[6, *, *])
   lnd_msk = REFORM(masks[1, *, *]) OR $
      REFORM(masks[2, *, *]) OR $
      REFORM(masks[3, *, *]) OR $
      REFORM(masks[4, *, *])

   ;  Locate the 9 L1B2 input files corresponding to the specified MISR Mode,
   ;  Path, and Orbit (here listed in alphabetical order of their names, AA,
   ;  AF, AN, BA, BF, CA, CF, DA, DF):
   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_l1b2_files = N_ELEMENTS(l1b2_files)

   ;  Identify the file containing the target MISR L1B2 data channel:
   cam_patt = '_' + misr_camera + '_'
   FOR i = 0, n_l1b2_files - 1 DO BEGIN
      idx = STRPOS(l1b2_files[i], cam_patt)
      IF (idx GT 1) THEN BEGIN
         target_l1b2_file = l1b2_files[i]
         BREAK
      ENDIF
   ENDFOR

   ;  Set the region of interest to the specified Block:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, misr_block, $
      misr_block, region)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error encountered in MTK_SETREGION_BY_PATH_BLOCKRANGE.'
      RETURN, error_code
   ENDIF

   ;  Read the target BRF dataset:
   target_grid = misr_band + 'Band'
   target_field = misr_band + ' Brf'
   status = MTK_READDATA(target_l1b2_file, target_grid, target_field, $
      region, target_databuf, mapinfo)
   IF ((debug) AND (status NE 0)) THEN BEGIN
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error encountered in MTK_READDATA while reading ' + $
         target_l1b2_file
      RETURN, error_code
   ENDIF

   ;  Define the arrays containing the computational results involving each
   ;  of the source data channels, separately for the ocean and land pixels:
   cam_oce_fit = STRARR(35)
   bnd_oce_fit = STRARR(35)
   npt_oce_fit = LONARR(35)
   rms_oce_fit = FLTARR(35)
   cor_oce_fit = FLTARR(35)
   cfa_oce_fit = FLTARR(35)
   cfb_oce_fit = FLTARR(35)
   chi_oce_fit = FLTARR(35)
   pro_oce_fit = FLTARR(35)

   cam_lnd_fit = STRARR(35)
   bnd_lnd_fit = STRARR(35)
   npt_lnd_fit = LONARR(35)
   rms_lnd_fit = FLTARR(35)
   cor_lnd_fit = FLTARR(35)
   cfa_lnd_fit = FLTARR(35)
   cfb_lnd_fit = FLTARR(35)
   chi_lnd_fit = FLTARR(35)
   pro_lnd_fit = FLTARR(35)

   ;  Initialize the best Chi square value retrieved so far to a large value:
   bst_oce_chi = 1000000.0
   bst_lnd_chi = 1000000.0

   ; Initialize the bext Pearson correlation coefficient so far to 0.0:
   bst_oce_cc = 0.0
   bst_lnd_cc = 0.0

   ;  Define a single index (i) into those 35 results and loop over the 9 MISR
   ;  L1B2 files (or cameras, in alphabetical order):
   iter = 0
   best_ocean = 0
   best_land = 0
   FOR cam = 0, n_l1b2_files - 1 DO BEGIN
      source_l1b2_file = l1b2_files[cam]

   ;  Identify the camera for this file (ignore the other elements):
      rc = fn2mpocv_l1b2(source_l1b2_file, misr_mode, source_path, $
         source_orbit, source_cam, source_version, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
         IF ((debug) AND (rc NE 0)) THEN BEGIN
            error_code = 320
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF

   ;  Loop over the 4 spectral bands of that file (or camera, in the order
   ;  specified by the function 'set_misr_specs.pro'):
      FOR bnd = 0, n_bnds - 1 DO BEGIN
         source_bnd = misr_bnds[bnd]

   ;  Skip the camera and band combination corresponding to the target data
   ;  channel:
         IF ((source_cam EQ misr_camera) AND $
            (source_bnd EQ misr_band)) THEN BEGIN
            CONTINUE
         ENDIF ELSE BEGIN

   ;  Set the resolution of the source data channel:
            source_resol = 275
            IF ((misr_mode EQ 'GM') AND (source_cam NE 'AN')) THEN BEGIN
               IF (source_bnd NE 'Red') THEN source_resol = 1100
            ENDIF
         ENDELSE

   ;  Save the camera and band names for the current iteration:
         cam_oce_fit[iter] = source_cam
         cam_lnd_fit[iter] = source_cam
         bnd_oce_fit[iter] = source_bnd
         bnd_lnd_fit[iter] = source_bnd

   ;  Read the data for that channel:
         source_grid = source_bnd + 'Band'
         source_field = source_bnd + ' Brf'
         status = MTK_READDATA(source_l1b2_file, source_grid, source_field, $
            region, source_databuf, mapinfo)
         IF ((debug) AND (status NE 0)) THEN BEGIN
            error_code = 330
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Error encountered in MTK_READDATA while reading ' + $
               source_l1b2_file
            RETURN, error_code
         ENDIF

   ;  Ensure that the spatial resolutions of the target and the source data
   ;  channels match, and if not, adjust the spatial resolution of the source
   ;  data channel:
         IF ((target_resol EQ 1100) AND (source_resol EQ 275)) THEN BEGIN
            source_databuf = hr2lr(source_databuf)
         ENDIF
         IF ((target_resol EQ 275) AND (source_resol EQ 1100)) THEN BEGIN
            source_databuf = lr2hr(source_databuf)
         ENDIF
         IF ((debug) AND (size(source_databuf, /N_ELEMENTS) NE $
            size(target_databuf, /N_ELEMENTS))) THEN BEGIN
            error_code = 340
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Target databuf contains ' + $
               strstr(size(target_databuf, /N_ELEMENTS)) + $
               ' elements but source target contains ' + $
               strstr(size(source_databuf, /N_ELEMENTS)) + $
               ' elements.'
            RETURN, error_code
         ENDIF

   ;  Locate the pixels with valid (> 0) values in both the source and the
   ;  target data channels, separately over ocean and land areas:
         kdx_oce = WHERE((source_databuf[*, *] GT 0.0) AND $
            (target_databuf[*, *] GT 0.0) AND $
            (oce_msk NE 0), n_oce_pts)
         npt_oce_fit[iter] = n_oce_pts
         kdx_lnd = WHERE((source_databuf[*, *] GT 0.0) AND $
            (target_databuf[*, *] GT 0.0) AND $
            (lnd_msk NE 0), n_lnd_pts)
         npt_lnd_fit[iter] = n_lnd_pts

   ;  Compute the statistical information separately for the ocean and land
   ;  areas:
         IF (n_oce_pts GT 0) THEN BEGIN

   ;  Extract the ocean values wherever the source and the target are both
   ;  available:
            source_oce_data = source_databuf[kdx_oce]
            target_oce_data = target_databuf[kdx_oce]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target ocean values wherever they are both available:
            numer = TOTAL((source_oce_data - target_oce_data) * $
               (source_oce_data - target_oce_data))
            rmsd = SQRT(numer / n_oce_pts)
            rms_oce_fit[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  ocean values wherever they are both available:
            cc = CORRELATE(source_oce_data, target_oce_data, /DOUBLE)
            cc_oce = FLOAT(cc)
            cor_oce_fit[iter] = cc_oce

   ;  Compute the linear fit equation to estimate the target from the source
   ;  ocean values wherever they are both available:
            res = LINFIT(source_oce_data, target_oce_data, CHISQR = chi, $
               PROB = prob, /DOUBLE)
            cfa_oce_fit[iter] = res[0]
            cfb_oce_fit[iter] = res[1]
            chi_oce_fit[iter] = chi
            pro_oce_fit[iter] = prob

   ;  Record whether this source camera/band combination results in a better
   ;  linear fit for ocean values:
            IF (chi LT bst_oce_chi) THEN BEGIN
               bst_oce_chi = chi
               best_ocean = iter
               best_source_databuf_oce = source_databuf
               best_kdx_oce = kdx_oce
               best_camera_oce = source_cam
               best_band_oce = source_bnd
               best_npts_oce = n_oce_pts
               best_rmsd_oce = rmsd
               best_cor_oce = cc_oce
               best_a_oce = res[0]
               best_b_oce = res[1]
               best_chisq_oce = chi
               best_prob_oce = prob
            ENDIF
         ENDIF ELSE BEGIN
            rms_oce_fit[iter] = -1.0
            cor_oce_fit[iter] = -1.0
            cfa_oce_fit[iter] = 0.0
            cfb_oce_fit[iter] = 0.0
            chi_oce_fit[iter] = 0.0
            pro_oce_fit[iter] = 0.0
         ENDELSE
         IF (n_lnd_pts GT 0) THEN BEGIN

   ;  Extract the land values wherever the source and the target are both
   ;  available:
            source_lnd_data = source_databuf[kdx_lnd]
            target_lnd_data = target_databuf[kdx_lnd]

   ;  Compute the root-mean-square deviation (RMSD) between the source and
   ;  the target land values wherever they are both available:
            numer = TOTAL((source_lnd_data - target_lnd_data) * $
               (source_lnd_data - target_lnd_data))
            rmsd = SQRT(numer / n_lnd_pts)
            rms_lnd_fit[iter] = rmsd

   ;  Compute the correlation coefficient between the source and the target
   ;  land values wherever they are both available:
            cc = CORRELATE(source_lnd_data, target_lnd_data, /DOUBLE)
            cc_lnd = FLOAT(cc)
            cor_lnd_fit[iter] = cc_lnd

   ;  Compute the linear fit equation to estimate the target from the source
   ;  land values wherever they are both available:
            res = LINFIT(source_lnd_data, target_lnd_data, CHISQR = chi, $
               PROB = prob, /DOUBLE)
            cfa_lnd_fit[iter] = res[0]
            cfb_lnd_fit[iter] = res[1]
            chi_lnd_fit[iter] = chi
            pro_lnd_fit[iter] = prob

   ;  Record whether this source camera/band combination results in a better
   ;  linear fit for ocean values:
            IF (chi LT bst_lnd_chi) THEN BEGIN
               bst_lnd_chi = chi
               best_land = iter
               best_source_databuf_lnd = source_databuf
               best_kdx_lnd = kdx_lnd
               best_camera_lnd = source_cam
               best_band_lnd = source_bnd
               best_npts_lnd = n_lnd_pts
               best_rmsd_lnd = rmsd
               best_cor_lnd = cc_lnd
               best_a_lnd = res[0]
               best_b_lnd = res[1]
               best_chisq_lnd = chi
               best_prob_lnd = prob
            ENDIF
         ENDIF ELSE BEGIN
            rms_lnd_fit[iter] = -1.0
            cor_lnd_fit[iter] = -1.0
            cfa_lnd_fit[iter] = 0.0
            cfb_lnd_fit[iter] = 0.0
            chi_lnd_fit[iter] = 0.0
            pro_lnd_fit[iter] = 0.0
         ENDELSE

   ;  Report on progress, if requested:
         IF (KEYWORD_SET(verbose)) THEN BEGIN
            PRINT, 'Done with Camera ' + source_cam + $
               ' and Band ' + source_bnd
         ENDIF
         iter = iter + 1

      ENDFOR
   ENDFOR

   ;  Sort the Chi square array in ascending order:
   idx_oce_sorted = SORT(chi_oce_fit)
   idx_lnd_sorted = SORT(chi_lnd_fit)

   ;  Generate and save the scatterplot for the best ocean and land fits,
   ;  if requested and if data are available for these areas:
   IF (KEYWORD_SET(scatterplot)) THEN BEGIN
      IF (npt_oce_fit[best_ocean] GT 0) THEN BEGIN

   ;  Set the title of the scatterplot:
         title_oce = 'Scatterplot for Ocean, with best linear fit'

   ;  Set the title of the X axis for the best ocean source data channel:
         source_title_oce = 'L1B2 BRF ' + misr_mode + ' ' + pob_str_space + $
            ' ' + cam_oce_fit[best_ocean] + ' ' + bnd_oce_fit[best_ocean]

   ;  Set the title of the Y axis for the ocean target data channel:
         target_title_oce = 'L1B2 BRF ' + misr_mode + ' ' + pob_str_space + $
            ' ' + misr_camera  + ' ' + misr_band

         prefix_oce = 'Bestfit_oce_'

   ;  Generate the scatterplot:
         rc = plt_scatt_gen(best_source_databuf_oce[best_kdx_oce], $
            source_title_oce, $
            target_databuf[best_kdx_oce], $
            target_title_oce, $
            title_oce, $
            pob_str, $
            misr_mode, $
            NPTS = npt_oce_fit[best_ocean], $
            RMSD = rms_oce_fit[best_ocean], $
            CORRCOEFF = cor_oce_fit[best_ocean], $
            LIN_COEFF_A = cfa_oce_fit[best_ocean], $
            LIN_COEFF_B = cfb_oce_fit[best_ocean], $
            CHISQR = chi_oce_fit[best_ocean], $
            PROB = pro_oce_fit[best_ocean], $
            PREFIX = prefix_oce, $
            VERBOSE = verbose, $
            DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         IF ((debug) AND (rc NE 0)) THEN BEGIN
            error_code = 500
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF
      IF (npt_lnd_fit[best_land] GT 0) THEN BEGIN

   ;  Set the title of the scatterplot:
         title_lnd = 'Scatterplot for Land, with best linear fit'

   ;  Set the title of the X axis for the best land source data channel:
         source_title_lnd = 'L1B2 BRF ' + misr_mode + ' ' + pob_str_space + $
            ' ' + cam_lnd_fit[best_land] + ' ' + bnd_lnd_fit[best_land]

   ;  Set the title of the Y axis for the land target data channel:
         target_title_lnd = 'L1B2 BRF ' + misr_mode + ' ' + pob_str_space + $
            ' ' + misr_camera  + ' ' + misr_band

         prefix_lnd = 'Bestfit_lnd_'

   ;  Generate the scatterplot:
         rc = plt_scatt_gen(best_source_databuf_lnd[best_kdx_lnd], $
            source_title_lnd, $
            target_databuf[best_kdx_lnd], $
            target_title_lnd, $
            title_lnd, $
            pob_str, $
            misr_mode, $
            NPTS = npt_lnd_fit[best_land], $
            RMSD = rms_lnd_fit[best_land], $
            CORRCOEFF = cor_lnd_fit[best_land], $
            LIN_COEFF_A = cfa_lnd_fit[best_land], $
            LIN_COEFF_B = cfb_lnd_fit[best_land], $
            CHISQR = chi_lnd_fit[best_land], $
            PROB = pro_lnd_fit[best_land], $
            PREFIX = prefix_lnd, $
            VERBOSE = verbose, $
            DEBUG = debug, $
            EXCPT_COND = excpt_cond)
         IF ((debug) AND (rc NE 0)) THEN BEGIN
            error_code = 510
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      ENDIF
   ENDIF

   idx_sorted_oce = SORT(chi_oce_fit)
   idx_sorted_lnd = SORT(chi_lnd_fit)

   ;  Generate and save the log file, if requested:
   IF (KEYWORD_SET(verbose)) THEN BEGIN
      fmt1 = '(A30, A)'
      log_fpath = root_dirs[3] + pob_str + '/L1B2_' + misr_mode + '/'
      rc = is_writable(log_fpath, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
         error_code = 520
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      IF (rc EQ -2) THEN FILE_MKDIR, log_fpath
      log_fname = 'Bestfit_L1B2_BRF_' + misr_mode + '_' + pob_str + $
         '_' + misr_camera + '_' + misr_band + '.txt'
      log_fspec = log_fpath + log_fname

      OPENW, log_unit, log_fspec, /GET_LUN
      PRINTF, log_unit, "File name: ", "'" + FILE_BASENAME(log_fspec) + $
         "'", FORMAT = fmt1
      PRINTF, log_unit, "Folder name: ", "'" + FILE_DIRNAME(log_fspec, $
         /MARK_DIRECTORY) + "'", FORMAT = fmt1
      PRINTF, log_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, log_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, log_unit, 'Saved on: ', date_time, FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Date of MISR acquisition: ' + acquis_date, $
         FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'MISR Path: ', strstr(misr_path), FORMAT = fmt1
      PRINTF, log_unit, 'MISR Orbit: ', strstr(misr_orbit), FORMAT = fmt1
      PRINTF, log_unit, 'MISR Block: ', strstr(misr_block), FORMAT = fmt1
      PRINTF, log_unit, 'Target Camera: ', misr_camera, FORMAT = fmt1
      PRINTF, log_unit, 'Target Band: ', misr_band, FORMAT = fmt1
      PRINTF, log_unit, 'Target Resolution: ', target_resol, FORMAT = fmt1
      PRINTF, log_unit

      PRINTF, log_unit, 'Results for ocean pixels:'
      PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
         'a', 'b', 'Chi sq', 'Proba', FORMAT = '(2(A6, 2X), A6, 2X, 6(A12))'
      PRINTF, log_unit, strrepeat('=', 96)
      FOR io = 0, N_ELEMENTS(idx_sorted_oce) - 1 DO BEGIN
         PRINTF, log_unit, $
            cam_oce_fit[idx_sorted_oce[io]], $
            bnd_oce_fit[idx_sorted_oce[io]], $
            npt_oce_fit[idx_sorted_oce[io]], $
            rms_oce_fit[idx_sorted_oce[io]], $
            cor_oce_fit[idx_sorted_oce[io]], $
            cfa_oce_fit[idx_sorted_oce[io]], $
            cfb_oce_fit[idx_sorted_oce[io]], $
            chi_oce_fit[idx_sorted_oce[io]], $
            pro_oce_fit[idx_sorted_oce[io]], $
            FORMAT = '(2(A6, 2X), I6, 2X, 6(F12.5))'
      ENDFOR
      PRINTF, log_unit
      PRINTF, log_unit, 'Results for land pixels:'
      PRINTF, log_unit, 'Cam', 'Band', 'N_pts', 'RMSD', 'Corr coeff', $
         'a', 'b', 'Chi sq', 'Proba', FORMAT = '(2(A6, 2X), A6, 2X, 6(A12))'
      PRINTF, log_unit, strrepeat('=', 96)
      FOR il = 0, N_ELEMENTS(idx_sorted_lnd) - 1 DO BEGIN
         PRINTF, log_unit, $
            cam_lnd_fit[idx_sorted_lnd[il]], $
            bnd_lnd_fit[idx_sorted_lnd[il]], $
            npt_lnd_fit[idx_sorted_lnd[il]], $
            rms_lnd_fit[idx_sorted_lnd[il]], $
            cor_lnd_fit[idx_sorted_lnd[il]], $
            cfa_lnd_fit[idx_sorted_lnd[il]], $
            cfb_lnd_fit[idx_sorted_lnd[il]], $
            chi_lnd_fit[idx_sorted_lnd[il]], $
            pro_lnd_fit[idx_sorted_lnd[il]], $
            FORMAT = '(2(A6, 2X), I6, 2X, 6(F12.5))'
      ENDFOR
      PRINTF, log_unit
      PRINT, 'The log file has been saved in ' + log_fspec
      CLOSE, log_unit
      FREE_LUN, log_unit
   ENDIF

   RETURN, return_code

END
