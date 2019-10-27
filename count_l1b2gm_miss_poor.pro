FUNCTION count_l1b2gm_miss_poor, $
   misr_path, $
   misr_block, $
   L1B2GM_FOLDER = l1b2gm_folder, $
   L1B2GM_VERSION = l1b2gm_version, $
   OUT_FOLDER = out_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function counts the number of bad (missing) and poor
   ;  data values in all MISR L1B2 Radiance files available in the
   ;  specified or default folder, and reports statistics by ORBIT, CAMERA
   ;  and BAND.
   ;
   ;  ALGORITHM: This function retrieves the list of all available ORBITS
   ;  in the specified or default folder, reads the Radiance and RDQI
   ;  databuffers, and counts the number of pixel values equal to 65523 as
   ;  bad and the number of RDQI values equal to 2B as poor.
   ;
   ;  SYNTAX: rc = count_l1b2gm_miss_poor(misr_path, misr_block, $
   ;  L1B2GM_FOLDER = l1b2gm_folder, L1B2GM_VERSION = l1b2gm_version, $
   ;  OUT_FOLDER = out_folder, VERBOSE = verbose, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INT} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_block {INT} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   L1B2GM_FOLDER = l1b2gm_folder {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 files, if they are not located in the
   ;      default location.
   ;
   ;  *   L1B2GM_VERSION = l1b2gm_version {STRING} [I] (Default value: Set
   ;      by function
   ;      set_roots_vers.pro): The L1B2 version identifier to use instead
   ;      of the default value.
   ;
   ;  *   OUT_FOLDER = out_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the output file(s).
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
   ;      provided in the call. The results are contained in the output
   ;      file, saved in the specified or default folder.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output file may be inexistent, incomplete or
   ;      incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: The input positional parameter misr_block is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: An exception condition occurred in function
   ;      path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      block2str.pro.
   ;
   ;  *   Error 299: The computer is not recognized and at least one of
   ;      the optional input keyword parameters l1b2gm_folder, out_folder
   ;      is not specified.
   ;
   ;  *   Error 300: The input folder l1b2_fpath is unreadable.
   ;
   ;  *   Error 310: The number of files in the folder containing MISR
   ;      L1B2 files is not a multiple of 9.
   ;
   ;  *   Error 400: The output folder out_fpath (output file for bad
   ;      values) is unwritable.
   ;
   ;  *   Error 410: The output folder out_fpath (output file for poor
   ;      values) is unwritable.
   ;
   ;  *   Error 600: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_SETREGION_BY_PATH_BLOCKRANGE.
   ;
   ;  *   Error 610: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_MAKE_FILENAME.
   ;
   ;  *   Error 620: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  *   Error 630: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_READDATA.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_readable_dir.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   orbit2date.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Because all available MISR L1B2 files need to be read,
   ;      this function is very time consuming: it can take 20+ minutes to
   ;      generate the statistics for a single BLOCK over the entire
   ;      mission period.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_block = 110
   ;      IDL> l1b2gm_folder = ''
   ;      IDL> l1b2gm_version = ''
   ;      IDL> out_folder = ''
   ;      IDL> verbose = 1
   ;      IDL> debug = 1
   ;      IDL> rc = count_l1b2gm_miss_poor(misr_path, misr_block, $
   ;         L1B2GM_FOLDER = l1b2gm_folder, $
   ;         L1B2GM_VERSION = l1b2gm_version, $
   ;         OUT_FOLDER = out_folder, VERBOSE = verbose, $
   ;         DEBUG = debug, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc)
   ;      rc = 0
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
   ;  *   2019–04–20: Version 1.0 — Initial release.
   ;
   ;  *   2019–04–21: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–04–25: Version 2.01 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–05–04: Version 2.02 — Update the code to report the
   ;      specific error message of MTK routines.
   ;
   ;  *   2019–05–07: Version 2.03 — Update the code to generate a
   ;      separate output file containing the statistics about poor
   ;      values.
   ;
   ;  *   2019–06–11: Version 2.04 — Update the code to include ELSE
   ;      options in all CASE statements and update the documentation.
   ;
   ;  *   2019–08–10: Version 2.05 — Rename this function
   ;      count_l1b2gm_miss_poor.pro.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
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
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, misr_block.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   n_cams = misr_specs.NCameras
   misr_cams = misr_specs.CameraNames
   n_bnds = misr_specs.NBands
   misr_bnds = misr_specs.BandNames

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
   IF (~KEYWORD_SET(l1b2gm_version)) THEN l1b2gm_version = versions[2]

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Generate the long string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the long string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF(~KEYWORD_SET(l1b2gm_folder) OR $
         ~KEYWORD_SET(out_folder)) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + '. And at least one of the optional input ' + $
            'keyword parameters l1b2gm_folder, out_folder is not specified.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the directory address of the folder containing the input L1B2 files
   ;  if it has not been set previously:
   IF (KEYWORD_SET(l1b2gm_folder)) THEN BEGIN
      rc = force_path_sep(l1b2gm_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      l1b2_fpath = l1b2gm_folder
   ENDIF ELSE BEGIN
      l1b2_fpath = root_dirs[1] + misr_path_str + PATH_SEP() + $
         'L1_GM' + PATH_SEP()
   ENDELSE

   ;  Return to the calling routine with an error message if the input
   ;  folder 'l1b2_fpath' is unreadable:
   IF (debug) THEN BEGIN
      res = is_readable_dir(l1b2_fpath)
      IF (res EQ 0) THEN BEGIN
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The input folder ' + l1b2_fpath + $
            ' is not found, not a directory or not readable.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Retrieve and count the names of all available MISR L1B2 Radiance files
   ;  for the specified Path:
   in_gm_files = FILE_SEARCH(l1b2_fpath + 'MISR*_GM_*.hdf', $
      COUNT = n_gm_files)
   IF (debug) THEN BEGIN
      tst = n_gm_files MOD 9
      IF (tst NE 0) THEN BEGIN
         error_code = 310
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The number of files in the folder containing MISR L1B2 ' + $
            'files is not a multiple of 9.'
         RETURN, error_code
      ENDIF
   ENDIF
   n_gm_orbits = n_gm_files / 9

   ;  Generate a STRING array of unique MISR L1B2 Orbit numbers:
   pos = STRPOS(in_gm_files[0], '_O')
   gm_orbits = STRMID(in_gm_files, pos + 2, 6)
   gm_orbits = gm_orbits[UNIQ(gm_orbits)]

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'Processing  Orbits: ', gm_orbits
   ENDIF

   ;  Set the directory address of the folder containing the outputs
   ;  if it has not been set previously:
   IF (KEYWORD_SET(out_folder)) THEN BEGIN
      rc = force_path_sep(out_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      out_fpath = out_folder
   ENDIF ELSE BEGIN
      out_fpath = root_dirs[3] + $
         misr_path_str + '-' + misr_block_str + PATH_SEP() + $
         'GM' + PATH_SEP()
   ENDELSE

   ;  Define the arrays that will contain the results:
   com_dat = STRARR(n_gm_orbits)
   com_jul = DBLARR(n_gm_orbits)
   n_miss_pts = LONARR(n_gm_orbits, 9, 4)
   n_poor_pts = LONARR(n_gm_orbits, 9, 4)

   ;  Define the (1-Block) region of interest to be the specified Block:
   status = MTK_SETREGION_BY_PATH_BLOCKRANGE(misr_path, $
      misr_block, misr_block, region)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 600
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Error message from MTK_SETREGION_BY_PATH_BLOCKRANGE: ' + $
         MTK_ERROR_MESSAGE(status)
      RETURN, error_code
   ENDIF

   ;  Loop over all available Orbits for which the L1B2 files are available:
   FOR i_gm_orbit = 0, n_gm_orbits - 1 DO BEGIN

   ;  Get the date and the Julian date of acquisition of the current Orbit:
      res = orbit2date(LONG(gm_orbits[i_gm_orbit]))
      com_dat[i_gm_orbit] = res
      res = orbit2date(LONG(gm_orbits[i_gm_orbit]), /JULIAN)
      com_jul[i_gm_orbit] = res

   ;  Generate the expected file names of the 9 L1B2 GRP camera files:
      gm_files = STRARR(9)
      status = MTK_MAKE_FILENAME(l1b2_fpath, 'GRP_TERRAIN_GM', 'DF', $
         STRING(misr_path), gm_orbits[i_gm_orbit], l1b2gm_version, out_filename)
      IF (debug AND (status NE 0)) THEN BEGIN
         error_code = 610
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Error message from MTK_MAKE_FILENAME: ' + $
            MTK_ERROR_MESSAGE(status)
         RETURN, error_code
      ENDIF

   ;  Ensure that this initial filename does not include wild characters:
      f = FILE_SEARCH(out_filename, COUNT = n_f)
      out_filename = f[0]

      gm_files[0] = out_filename
      gm_files[1] = out_filename.Replace('DF', 'CF')
      gm_files[2] = out_filename.Replace('DF', 'BF')
      gm_files[3] = out_filename.Replace('DF', 'AF')
      gm_files[4] = out_filename.Replace('DF', 'AN')
      gm_files[5] = out_filename.Replace('DF', 'AA')
      gm_files[6] = out_filename.Replace('DF', 'BA')
      gm_files[7] = out_filename.Replace('DF', 'CA')
      gm_files[8] = out_filename.Replace('DF', 'DA')

   ;  Loop over the Cameras:
      FOR i_cam = 0, n_cams - 1 DO BEGIN

   ;  Loop over the 4 spectral bands for that Camera:
         FOR i_band = 0, n_bnds - 1 DO BEGIN
            band_name = misr_bnds[i_band]

   ;  Set the grid and field to read the scaled radiances:
            grid = band_name + 'Band'
            field = band_name + ' Radiance/RDQI'

   ;  Read the Radiance data for that grid and field:
            status = MTK_READDATA(gm_files[i_cam], grid, field, region, $
               databuf, mapinfo)
            IF (debug AND (status NE 0)) THEN BEGIN
               error_code = 620
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Error message from MTK_READDATA: ' + $
                  MTK_ERROR_MESSAGE(status)
               RETURN, error_code
            ENDIF

   ;  Retrieve the number of missing values:
            idx = WHERE(databuf EQ 65523, nmiss)
            IF (nmiss GT 0) THEN BEGIN
               n_miss_pts[i_gm_orbit, i_cam, i_band] = nmiss
            ENDIF

   ;  Set the grid and field to read the RDQI:
            grid = band_name + 'Band'
            field = band_name + ' RDQI'

   ;  Read the RDQI data for that grid and field:
            status = MTK_READDATA(gm_files[i_cam], grid, field, region, $
               databuf, mapinfo)
            IF (debug AND (status NE 0)) THEN BEGIN
               error_code = 630
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Error message from MTK_READDATA: ' + $
                  MTK_ERROR_MESSAGE(status)
               RETURN, error_code
            ENDIF

   ;  Retrieve the number of poor values:
            idx = WHERE(databuf EQ 2B, npoor)
            IF (npoor GT 0) THEN BEGIN
               n_poor_pts[i_gm_orbit, i_cam, i_band] = npoor
            ENDIF
         ENDFOR   ;  Loop over spectral bands
      ENDFOR   ;  Loop over files

      IF (verbose GT 0) THEN BEGIN
         tst = i_gm_orbit MOD 50
         IF ((i_gm_orbit GT 0) AND (tst EQ 0)) THEN BEGIN
            PRINT, 'Processed ' + strstr(i_gm_orbit) + ' Orbits.'
         ENDIF
      ENDIF

   ENDFOR   ;  Loop over available Orbits

   ;   Generate the name of the output file for bad (missing) values:
   out_fname = 'Num_L1B2_miss_' + misr_path_str + '-' + misr_block_str + $
      '_' + com_dat[0] + '_' + com_dat[n_gm_orbits - 1] + '.txt'
   out_fspec = out_fpath + out_fname

   ;  Create the output directory 'out_fpath' if it does not exist, and
   ;  return to the calling routine with an error message if it is unwritable:
   res = is_writable_dir(out_fpath, /CREATE)
   IF (debug AND (res NE 1)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The directory out_fpath is unwritable.'
      RETURN, error_code
   ENDIF

   ;  Open the output file:
   OPENW, out_unit, out_fspec, /GET_LUN

   fmt1 = '(A4, 2X, A6, 2X, A12, 2X, A12, 9(2X, A30), 2X, A10)'
   fmt2 = '(A4, 2X, A6, 2X, A12, 2X, A12, 36(2X, A6), 2X, A10)'
   fmt3 = '(I4, 2X, I6, 2X, A12, 2X, F12.2, 36(2X, I6), 2X, I10)'

   ;  Write the header:
   title = 'Statistics on the number of missing L1B2 values by ' + $
      'Orbit, Camera and Band for Path ' + strstr(misr_path) + ' and Block ' + $
      strstr(misr_block)
   PRINTF, out_unit, title
   subtitle = ['#', 'Orbit', 'Cal date', 'Julian date', 'DF', 'CF', $
      'BF', 'AF', 'AN', 'AA', 'BA', 'CA', 'DA', 'Total']
   PRINTF, out_unit, subtitle, FORMAT = fmt1
   bnds4 = ['Blu', 'Grn', 'Red', 'NIR']
   col_head = ['', '', '', '', bnds4, bnds4, bnds4, bnds4, bnds4, bnds4, $
      bnds4, bnds4, bnds4]
   PRINTF, out_unit, col_head, FORMAT = fmt2
   PRINTF, out_unit, strrepeat("=", 340)

   ;  Write the results:
   FOR i_orbit = 0, n_gm_orbits - 1 DO BEGIN
      PRINTF, out_unit, i_orbit, gm_orbits[i_orbit], $
         com_dat[i_orbit], com_jul[i_orbit], $
         n_miss_pts [i_orbit, 0, *], $
         n_miss_pts [i_orbit, 1, *], $
         n_miss_pts [i_orbit, 2, *], $
         n_miss_pts [i_orbit, 3, *], $
         n_miss_pts [i_orbit, 4, *], $
         n_miss_pts [i_orbit, 5, *], $
         n_miss_pts [i_orbit, 6, *], $
         n_miss_pts [i_orbit, 7, *], $
         n_miss_pts [i_orbit, 8, *], $
         TOTAL(n_miss_pts [i_orbit, *, *]), FORMAT = fmt3
   ENDFOR

   ;  Close the output file:
   FREE_LUN, out_unit

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'The results have been saved in the output file'
      PRINT, out_fspec
   ENDIF

   ;   Generate the name of the output file for poor values:
   out_fname = 'Num_L1B2_poor_' + misr_path_str + '-' + misr_block_str + $
      '_' + com_dat[0] + '_' + com_dat[n_gm_orbits - 1] + '.txt'
   out_fspec = out_fpath + out_fname

   ;  Create the output directory 'out_fpath' if it does not exist, and
   ;  return to the calling routine with an error message if it is unwritable:
   res = is_writable_dir(out_fpath, /CREATE)
   IF (debug AND (res NE 1)) THEN BEGIN
      error_code = 410
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The directory out_fpath is unwritable.'
      RETURN, error_code
   ENDIF

   ;  Open the output file:
   OPENW, out_unit, out_fspec, /GET_LUN

   fmt1 = '(A4, 2X, A6, 2X, A12, 2X, A12, 9(2X, A30), 2X, A10)'
   fmt2 = '(A4, 2X, A6, 2X, A12, 2X, A12, 36(2X, A6), 2X, A10)'
   fmt3 = '(I4, 2X, I6, 2X, A12, 2X, F12.2, 36(2X, I6), 2X, I10)'

   ;  Write the header:
   title = 'Statistics on the number of poor L1B2 values by ' + $
      'Orbit, Camera and Band for Path ' + strstr(misr_path) + ' and Block ' + $
      strstr(misr_block)
   PRINTF, out_unit, title
   subtitle = ['#', 'Orbit', 'Cal date', 'Julian date', 'DF', 'CF', $
      'BF', 'AF', 'AN', 'AA', 'BA', 'CA', 'DA', 'Total']
   PRINTF, out_unit, subtitle, FORMAT = fmt1
   bnds4 = ['Blu', 'Grn', 'Red', 'NIR']
   col_head = ['', '', '', '', bnds4, bnds4, bnds4, bnds4, bnds4, bnds4, $
      bnds4, bnds4, bnds4]
   PRINTF, out_unit, col_head, FORMAT = fmt2
   PRINTF, out_unit, strrepeat("=", 340)

   ;  Write the results:
   FOR i_orbit = 0, n_gm_orbits - 1 DO BEGIN
      PRINTF, out_unit, i_orbit, gm_orbits[i_orbit], $
         com_dat[i_orbit], com_jul[i_orbit], $
         n_poor_pts [i_orbit, 0, *], $
         n_poor_pts [i_orbit, 1, *], $
         n_poor_pts [i_orbit, 2, *], $
         n_poor_pts [i_orbit, 3, *], $
         n_poor_pts [i_orbit, 4, *], $
         n_poor_pts [i_orbit, 5, *], $
         n_poor_pts [i_orbit, 6, *], $
         n_poor_pts [i_orbit, 7, *], $
         n_poor_pts [i_orbit, 8, *], $
         TOTAL(n_poor_pts [i_orbit, *, *]), FORMAT = fmt3
   ENDFOR

   ;  Close the output file:
   FREE_LUN, out_unit

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'The results have been saved in the output file'
      PRINT, out_fspec
   ENDIF

   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

   RETURN, return_code

END
