PRO doc_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This program generates an exhaustive characterization of
   ;  the data contained in the MISR L1B2 Georectified Radiance Product
   ;  (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance files
   ;  corresponding to the specified input positional parameters , PATH,
   ;  ORBIT and BLOCK. and BLOCK.
   ;
   ;  ALGORITHM: This program calls the various diagnostic, statistical
   ;  and mapping functions within this project to provide a full
   ;  characterization of the MISR L1B2 Georectified Radiance Product
   ;  (GRP) Terrain-Projected Top of Atmosphere (ToA) Radiance files
   ;  corresponding to the specified input positional parameters MODE,
   ;  PATH, ORBIT and BLOCK. and BLOCK.
   ;
   ;  SYNTAX: doc_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond
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
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call.
   ;      If the input positional parameters specify a set of Global Mode
   ;      files, this program generates 861 files in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_GM/’:
   ;
   ;      -   54 files generated by diag_l1b2_gm.pro
   ;
   ;      -   698 files generated by cor_l1b2_gm.pro
   ;
   ;      -   72 files generated by map_l1b2_gm_block.pro
   ;
   ;      -   37 files generated by map_l1b2_gm_miss.pro
   ;
   ;      If the input positional parameters specify a set of Local Mode
   ;      files, this program generates 861 files in the folder
   ;      root_dirs[3] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_LM/’:
   ;
   ;      -   54 files generated by diag_l1b2_gm.pro
   ;
   ;      -   698 files generated by cor_l1b2_gm.pro
   ;
   ;      -   72 files generated by map_l1b2_gm_block.pro
   ;
   ;      -   37 files generated by map_l1b2_gm_miss.pro
   ;
   ;      See the documentation of these functions for further details.
   ;
   ;  *   If an exception condition has been detected, the optional output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered, if the optional input keyword
   ;      parameter DEBUG is set and if the optional output keyword
   ;      parameter EXCPT_COND is provided. This program prints an error
   ;      message and returns control to the calling program or to the
   ;      console; no or only partial output may be generated.
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
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 400: An exception condition occurred in function
   ;      get_l1b2_files.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   best_fit_l1b2.pro
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
   ;  *   cor_l1b2.pro
   ;
   ;  *   diag_l1b2.pro
   ;
   ;  *   get_l1b2_files.pro
   ;
   ;  *   map_l1b2_block.pro
   ;
   ;  *   map_l1b2_miss.pro
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
   ;  *   NOTE 1: *** WARNING ***: The functions implementing the core of
   ;      the work must be called in the proper order, as some of them
   ;      depend on the results obtained by earlier ones.
   ;
   ;  *   NOTE 2: *** WARNING ***: Running this program takes well over an
   ;      hour (>3900 s) on MicMac.
   ;
   ;  *   NOTE 3: This program calls the diagnostic and mapping functions
   ;      with default options. To select custom options, call those
   ;      functions individually.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> doc_l1b2, 'GM', 168, 68050, 110, $
   ;         /DEBUG, EXCPT_COND = excpt_cond
   ;
   ;      results in the creation of all output files generated by the functions
   ;      diag_l1b2, cor_l1b2, map_l1b2_block, and map_l1b2_miss.
   ;
   ;  REFERENCES: None.
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
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         STOP
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   cams = misr_specs.CameraNames
   n_bands = misr_specs.NBands
   bands = misr_specs.BandNames

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   ;  Generate the string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF

   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, error_code
      STOP
   ENDIF
   n_files = N_ELEMENTS(l1b2_files)

   PRINT
   PRINT, 'Documenting the MISR L1B2 ' + misr_mode + ' data for Path ' + $
      misr_path_str + ', Orbit ' + misr_orbit_str + ' and Block ' + misr_block_str + '.'
   PRINT
   TIC

   ;  Collect diagnostic information (metadata) on this Block:
   PRINT, '1. Collecting diagnostic information (metadata):'
   clock1 = TIC('Step 1')
   rc = diag_l1b2(misr_mode, misr_path, misr_orbit, misr_block, $
      /HISTOGRAMS, DEBUG = debug, EXCPT_COND = excpt_cond)
   TOC, clock1
   IF (rc NE 0) THEN BEGIN
      PRINT, '*** WARNING ***'
      PRINT, 'Upon return from diag_l1b2, rc = ' + strstr(rc) + ' and'
      PRINT, '   excpt_cond = ' + excpt_cond
   ENDIF
   PRINT

   ;  Identify the best predictor for each data channel:
   PRINT, '2. Compute the best predictor for each data channel:'
   clock2 = TIC('Step 2')
   FOR i = 0, n_cams - 1 DO BEGIN
      misr_camera = cams[i]
      FOR j = 0, n_bands - 1 DO BEGIN
         misr_band = bands[j]
         rc = best_fit_l1b2(misr_mode, misr_path, misr_orbit, misr_block, $
            misr_camera, misr_band, best_camera_oce, best_band_oce, $
            best_npts_oce, best_rmsd_oce, best_cor_oce, best_a_oce, $
            best_b_oce, best_chisq_oce, best_prob_oce, best_camera_lnd, $
            best_band_lnd, best_npts_lnd, best_rmsd_lnd, best_cor_lnd, $
            best_a_lnd, best_b_lnd, best_chisq_lnd, best_prob_lnd, $
            AGP_VERSION = agp_version, /VERBOSE, /SCATTERPLOT, $
            DEBUG = debug, EXCPT_COND = excpt_cond)
         IF (rc NE 0) THEN BEGIN
            PRINT, '*** WARNING ***'
            PRINT, 'Upon return from best_fit_l1b2, rc = ' + strstr(rc) + ' and'
            PRINT, '   excpt_cond = ' + excpt_cond
         ENDIF
         PRINT, 'Done best predictor for ' + misr_camera + '/' + misr_band + '.'
      ENDFOR
   ENDFOR
   TOC, clock2
   PRINT

   ;  Map the L1B2 data channels, using the default scaling factors:
   PRINT, '3. Mapping the L1B2 data channels:'
   clock3 = TIC('Step 3')
   rc = map_l1b2_block(misr_mode, misr_path, misr_orbit, misr_block, $
      /RGB_LOW, /RGB_HIGH, /PER_BAND, DEBUG = debug, EXCPT_COND = excpt_cond)
   TOC, clock3
   PRINT

   ;  Map the spatial distribution of fill values:
   PRINT, '4. Mapping the spatial distribution of fill values:'
   clock4 = TIC('Step 4')
   rc = map_l1b2_miss(misr_mode, misr_path, misr_orbit, misr_block, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   TOC, clock4
   PRINT

   TOC

END