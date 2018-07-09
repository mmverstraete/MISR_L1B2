FUNCTION diag_l1b2, misr_mode, misr_path, misr_orbit, misr_block, $
   HISTOGRAMS = histograms, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function collects metadata and basic statistics about
   ;  the contents of a single MISR BLOCK within each of the 9 MISR L1B2
   ;  Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) Global Mode (GM) or Local Mode (LM) Radiance files
   ;  for the specified MISR PATH, ORBIT, and BLOCK, and saves these
   ;  results into 9 text files and 9 corresponding IDL SAVE files. This
   ;  function also optionally generates histograms of the ToA BRF values
   ;  found in each spectral data channel and saves them in the output
   ;  folder if the keyword HISTOGRAMS is set.
   ;
   ;  ALGORITHM: This function relies on the function diag_l1b2_block to
   ;  retrieve the desired information about each camera file for the
   ;  specified MISR PATH, ORBIT, and BLOCK, and saves the 18 .txt and
   ;  .sav output files.
   ;
   ;  SYNTAX:
   ;  rc = diag_l1b2(misr_mode, misr_path, misr_orbit, misr_block, $
   ;  HISTOGRAMS = histograms, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {INTEGER} [I]: The selected MISR MODE.
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   HISTOGRAMS = histograms {INTEGER} [I]: Optional keyword
   ;      parameter to request (1) or skip (0) the plotting of histograms
   ;      of data channel values.
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
   ;      provided in the call. This function saves 18 output files in the
   ;      folder
   ;      root_dirs[2] + ’/Pxxx_Oyyyyyy_Bzzz/L1B2_[misr_mode]/’:
   ;
   ;      -   9 plain text output files containing diagnostic information
   ;          for each camera, named
   ;          diag_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_[YYYY-MM-DD]_
   ;          [MISR-Version]_[creation-date].txt.
   ;
   ;      -   9 IDL SAVE output files containing diagnostic information
   ;          for each camera, named
   ;          diag_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]_[YYYY-MM-DD]_
   ;          [MISR-Version]_[creation-date].sav.
   ;
   ;      In addition, if the optional input keyword parameter HISTOGRAMS
   ;      is set in the call, the function diag_l1b2_[misr_mode]_block.pro
   ;      called by this routine will also generate
   ;
   ;      -   36 histograms of the ToA BRF values found in these data
   ;          channels, named
   ;          diag-hist_Pxxx_Oyyyyyy_Bzzz_L1B2_[misr_mode]_[camera_name]-[field]_
   ;          [YYYY-MM-DD]_[MISR-Version]_[creation_date].png.
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
   ;      orbit2date.pro.
   ;
   ;  *   Error 300: An exception condition occurred in function
   ;      diag_l1b2_block.pro.
   ;
   ;  *   Error 400: An exception condition occurred in function
   ;      get_l1b2_files.
   ;
   ;  *   Error 500: An exception condition occurred in function
   ;      is_writable.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   diag_l1b2_block.pro
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   get_l1b2_files.pro
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
   ;  *   NOTE 1: This program assumes that available input MISR L1B2 GM
   ;      or LM files are grouped together in a standard location defined
   ;      by the function set_root_dirs.pro.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = diag_l1b2('GM', 168, 68050, 110, $
   ;         /HISTOGRAMS, /DEBUG, EXCPT_COND = excpt_cond)
   ;
   ;      results in the creation of 9 plain text files, 9 .sav files and
   ;      36 histograms in the folder root_dirs[3] + '/P168_O068050_B110/L1B2_GM/'.
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–14: Version 0.8 — Initial release under the name
   ;      diag_l1b2.pro.
   ;
   ;  *   2017–10–10: Version 0.9 — Changed the name of the function to
   ;      diag_l1b2_gm.pro.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–03–04: Version 1.1 — Update the function to rely on
   ;      get_l1b2_gm_files.pro instead of chk_l1b2_gm_files.pro.
   ;
   ;  *   2018–04–08: Version 1.2 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–06–01: Version 1.3 — Merge this function with its twin
   ;      diag_l1b2_lm.pro and change the name back to diag_l1b2.pro.
   ;
   ;  *   2018–06–07: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–06–17: Version 1.6 — Add MISR version number in the names
   ;      of the output files.
   ;
   ;  *   2018–07–07: Version 1.7 — Update this routine to rely on the new
   ;      function get_host_info.pro and the updated version of the
   ;      function set_root_dirs.pro; and to take advantage of the updated
   ;      version of function diag_l1b2_block.pro.
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

   ;  Identify the current operating system and computer name:
   rc = get_host_info(os_name, comp_name)

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()

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
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str

   ;  Get the date of acquisition of this MISR Orbit:
   acquis_date = orbit2date(LONG(misr_orbit), DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Get the file specifications of the 9 L1B2 files corresponding to the
   ;  inputs above:
   rc = get_l1b2_files(misr_mode, misr_path, misr_orbit, l1b2_files, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   n_files = N_ELEMENTS(l1b2_files)

   ;  Set the path to the folder containing the output diagnostic files:
   o_path = root_dirs[3] + pob_str + '/L1B2_' + misr_mode + '/'
   rc = is_writable(o_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, o_path

   i_cams = STRARR(n_files)
   i_vers = STRARR(n_files)
   o_specs = STRARR(n_files)
   fmt1 = '(A30, A)'

   FOR i = 0, n_files - 1 DO BEGIN

   ;  Get the camera name and the MISR version number from the input filename:
      parts = STRSPLIT(FILE_BASENAME(l1b2_files[i], '.hdf'), '_', $
         COUNT = n_parts, /EXTRACT)
      i_cams[i] = parts[7]
      status = MTK_FILE_VERSION(l1b2_files[0], misr_version)
      i_vers[i] = misr_version

      local_fname = 'diag_' + pob_str + '_L1B2_' + misr_mode + '_' + $
         i_cams[i] + '_' + acquis_date + '_' + i_vers[i] + '_' + date
      o_specs[i] = o_path + local_fname + '.txt'

   ;  Save the outcome in a separate diagnostic file for each camera:
      OPENW, o_unit, o_specs[i], /GET_LUN
      PRINTF, o_unit, "File name: ", "'" + local_fname + "'", FORMAT = fmt1
      PRINTF, o_unit, "Folder name: ", o_path, FORMAT = fmt1
      PRINTF, o_unit, 'Generated by: ', rout_name, FORMAT = fmt1
      PRINTF, o_unit, 'Generated on: ', comp_name, FORMAT = fmt1
      PRINTF, o_unit, 'Saved on: ', date, FORMAT = fmt1
      PRINTF, o_unit

      PRINTF, o_unit, 'Date of MISR acquisition: ' + acquis_date
      PRINTF, o_unit

      PRINTF, o_unit, 'Content: Metadata summary for a single Block of a single'
      PRINTF, o_unit, 'MISR L1B2 Terrain-projected Global Mode (camera) file.'
      PRINTF, o_unit

   ;  Gather the metadata for that file:
      rc = diag_l1b2_block(l1b2_files[i], misr_block, meta_data, $
         HISTOGRAMS = histograms, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF ((debug) AND (rc NE 0)) THEN BEGIN
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': ' + excpt_cond
      ENDIF

   ;  Save the alphanumeric results contained in the structure 'meta_data' in
   ;  a camera-specific '.sav' file:
      sav_fspec = o_path + local_fname + '.sav'
      SAVE, meta_data, FILENAME = sav_fspec
      PRINTF, o_unit, 'File ' + FILE_BASENAME(sav_fspec) + ' created.'
      PRINTF, o_unit

   ;  Print each diagnostic structure tag and its value in the diagnostic log
   ;  file:
      ntags = N_TAGS(meta_data)
      tagnames = TAG_NAMES(meta_data)
      nd = oom(ntags, BASE = 10.0, DEBUG = debug, EXCPT_COND = excpt_cond) + 1
      fmt2 = '(I' + strstr(nd) + ', A29, 3X, A)'

   ;  Generic HDF file information:
      FOR itag = 0, 7 DO BEGIN
         PRINTF, o_unit, FORMAT = fmt2, $
            itag, tagnames[itag], strstr(meta_data.(itag))
      ENDFOR
      PRINTF, o_unit

   ;  Number of Grids in this HDF file:
      PRINTF, o_unit, FORMAT = fmt2, $
         8, tagnames[8], strstr(meta_data.(8))

   ;  Print the rest of the structure:
      FOR itag = 9, ntags - 1 DO BEGIN
         IF (STRPOS(strstr(meta_data.(itag)), 'Band') GT 0) THEN PRINTF, o_unit
         PRINTF, o_unit, FORMAT = fmt2, $
            itag, tagnames[itag], strstr(meta_data.(itag))
      ENDFOR

      FREE_LUN, o_unit
      CLOSE, o_unit

      PRINT, 'File ' + sav_fspec + ' created.'
      PRINT, 'File ' + o_specs[i] + ' created.'
   ENDFOR

END
