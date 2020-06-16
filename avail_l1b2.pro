PRO avail_l1b2, $
   misr_mode, $
   L1B2_FOLDER = l1b2_folder, $
   L1B2_VERSION = l1b2_version, $
   OUT_FOLDER = out_folder, $
   VERBOSE = verbose, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This program saves information on the availability of MISR
   ;  L1B2 Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) Radiance files in either Global or Local Mode on
   ;  the current computer at the time of execution.
   ;
   ;  ALGORITHM: This program (1) relies on the function avail_l1b2_data
   ;  to search for and report on the availability of the MISR L1B2
   ;  Georectified Radiance Product (GRP) Terrain-Projected Top of
   ;  Atmosphere (ToA) Radiance files in either Global (GM) or Local Mode
   ;  (LM) on the computer executing this program, and (2) saves the
   ;  information in a log file located in the specified or default
   ;  folder.
   ;
   ;  SYNTAX: avail_l1b2_gm, misr_mode, $
   ;  L1B2_FOLDER = l1b2_folder, L1B2_VERSION = l1b2_version, $
   ;  VERBOSE = verbose, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: A 2-character parameter indicating
   ;      whether to report on the availability of Global (GM) or Local
   ;      (LM) Mode files.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   L1B2_FOLDER = l1b2_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the MISR L1B2 files, if they are not located in the
   ;      default location.
   ;
   ;  *   L1B2_VERSION = l1b2_version {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The L1B2 version identifier to use instead
   ;      of the default value.
   ;
   ;  *   OUT_FOLDER = out_folder {STRING} [I] (Default value: Set by
   ;      function
   ;      set_roots_vers.pro): The directory address of the folder
   ;      containing the output file.
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
   ;  RETURNED VALUE TYPE: N/A.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, the keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call. An output
   ;      file named
   ;      Avail_L1B2_rad_’ + [misr_mode] + ’_’ + [comp_name] + ’_MISR-Mission_’ + date + ’.txt’
   ;      and located in the default or the specified output folder
   ;      contains information on the availability of MISR L1B2 files of
   ;      the specified MODE in the folders of root_dirs[1] on the
   ;      computer comp_name at the time of execution [creation_date].
   ;
   ;  *   If an exception condition has been detected, the optional output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered and this program prints out the
   ;      error message if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output file may be inexistent, incomplete or
   ;      useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Warning 98: The computer has not been recognized by the function
   ;      get_host_info.pro.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_mode is invalid.
   ;
   ;  *   Error 199: An exception condition occurred in
   ;      set_roots_vers.pro.
   ;
   ;  *   Error 200: Unrecognized misr_mode.
   ;
   ;  *   Error 299: The computer is not recognized and the optional input
   ;      keyword parameters l1b2_folder is not specified.
   ;
   ;  *   Error 300: No directories containing MISR L1B2 files of the
   ;      specified MODE have been found at the specified or default
   ;      locations on this computer.
   ;
   ;  *   Error 400: The directory out_fpath is unwritable.
   ;
   ;  *   Error 500: An exception condition occurred in
   ;      avail_l1b2_data.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   avail_l1b2_data.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   force_path_sep.pro
   ;
   ;  *   get_host_info.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_writable_dir.pro
   ;
   ;  *   set_roots_vers.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This program works equally well with GM and LM files.
   ;
   ;  *   NOTE 2: This program currently reports on the first and last
   ;      MISR L1B2 data files of the specified MODE found in the
   ;      specified or default places on this computer. It does not verify
   ;      the availability of all 9 L1B2 files per ORBIT, or of the
   ;      associated Geometric Parameters and L2 Land Surface files, which
   ;      are also required by the MISR-HR processing system. Nor does it
   ;      report on the version status of the data files.
   ;
   ;  *   NOTE 3: Assuming (1) that the L1B2 Geometric Parameters Product
   ;      (GPP) and L2 Land Surface Product (LSP) files are systematically
   ;      acquired together with the L1B2 GRP files, (2) that the standard
   ;      Ancillary Geographic Product (AGP) files for those PATHS are
   ;      available, and (3) that the acquisition of MISR L1B2 GRP files
   ;      include complete ORBITS (as opposed to subsets of one or a few
   ;      BLOCKS), this program reports on the spatial domain and temporal
   ;      range for which MISR-HR products derived from the Global Mode
   ;      data can be generated on this computer.
   ;
   ;  EXAMPLES:
   ;
   ;      [On MicMac2:]
   ;
   ;      IDL> avail_l1b2, 'GM', /VERBOSE, /DEBUG, EXCPT_COND = excpt_cond
   ;      The output file
   ;      Avail_L1B2_rad_GM_MISR-Mission_2018-12-26.txt
   ;      has been created in the folder
   ;      ~/MISR_HR/Outcomes/Available/L1B2_GM
   ;      IDL> SPAWN, 'cat ~/MISR_HR/Outcomes/Available/L1B2_GM/
   ;         File name: Avail_L1B2_rad_GM_MISR-Mission_2018-12-26.txt
   ;       Folder name: ~/MISR_HR/Outcomes/Available/L1B2_GM/
   ;      Generated by: AVAIL_L1B2
   ;      Generated on: MicMac2
   ;          Saved on: 2018-12-26 at 20:48:45
   ;
   ;        Content: MISR L1B2 GM data availability
   ;
   ;                      Directory names Sizes # files      From          To
   ;                      --------------- ----- -------      ----          --
   ;      /Volumes/MISR_Data3/P168/L1_GM/  632G  3582  2000-03-24  2017-11-18
   ;      /Volumes/MISR_Data3/P169/L1_GM/  560G  3159  2000-02-28  2015-11-20
   ;      /Volumes/MISR_Data3/P170/L1_GM/  558G  3177  2000-03-06  2015-11-27
   ;      /Volumes/MISR_Data3/P171/L1_GM/  546G  3137  2000-02-26  2015-11-18
   ;      /Volumes/MISR_Data3/P176/L1_GM/  542G  3150  2000-02-29  2015-11-21
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
   ;  *   2017–-07–-24: Version 0.8 —– Initial release, under the name
   ;      avail_l1b2_gm.pro.
   ;
   ;  *   2017–-12–-18: Version 0.9 —– Update Output format.
   ;
   ;  *   2018-–01–-30: Version 1.0 –— Initial public release.
   ;
   ;  *   2018-–04-–08: Version 1.1 –— Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018-–05-–03: Version 1.2 –— Merge this function with its twin
   ;      avail_l1b2_lm.pro and change the name to avail_l1b2.pro.
   ;
   ;  *   2018–-05–-14: Version 1.3 –— Update this function to use the
   ;      revised version of is_writable.pro and update the documentation.
   ;
   ;  *   2018-–05-–18: Version 1.5 –— Implement new coding standards.
   ;
   ;  *   2018–-07–-05: Version 1.6 –— Update this routine to rely on the
   ;      new function get_host_info.pro and the updated version of the
   ;      function set_root_dirs.pro.
   ;
   ;  *   2018–-12–24: Version 1.7 — Update this routine to rely on the
   ;      new function
   ;      set_roots_vers.pro.
   ;
   ;  *   2019–03–01: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–03–20: Version 2.01 — Update the handling of the optional
   ;      input keyword parameter VERBOSE and generate the software
   ;      version consistent with the published documentation.
   ;
   ;  *   2019–06-11: Version 2.02 — Update the code to include ELSE
   ;      options in all CASE statements, add the version identifier to
   ;      the output file and update the documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the use of
   ;      verbose and the assignment of numeric return codes), and switch
   ;      to 3-parts version identifiers.
   ;
   ;  *   2019–12–19: Version 2.1.1 — Bug fix (replace RETURN by STOP
   ;      statements).
   ;
   ;  *   2020–03–30: Version 2.1.5 — Software version described in the
   ;      preprint published in _ESSDD_ referenced above.
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

   ;  Set the default values of flags and essential output keyword parameters:
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
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameters: misr_mode.'
         PRINT, error_code
         RETURN
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_mode' is invalid:
      rc = chk_misr_mode(misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         PRINT, error_code
         RETURN
      ENDIF
   ENDIF

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
      PRINT, error_code
      RETURN
   ENDIF

   ;  Set the MISR and MISR-HR version numbers if they have not been specified
   ;  explicitly:
   IF (~KEYWORD_SET(l1b2_version)) THEN BEGIN
      CASE misr_mode OF
         'GM': l1b2_version = versions[2]
         'LM': l1b2_version = versions[3]
         ELSE: BEGIN
            error_code = 200
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Unrecognized misr_mode.'
            PRINT, error_code
            RETURN
         END
      ENDCASE
   ENDIF

   ;  Get today's date:
   date = today(FMT = 'ymd')

   ;  Get today's date and time:
   date_time = today(FMT = 'nice')

   ;  Return to the calling routine with an error message if the routine
   ;  'set_roots_vers.pro' could not assign valid values to the array root_dirs
   ;  and the required MISR and MISR-HR root folders have not been initialized:
   IF (debug AND (rc_roots EQ 99)) THEN BEGIN
      IF (~KEYWORD_SET(l1b2_folder)) THEN BEGIN
         error_code = 299
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond + ' And the optional input keyword parameter' + $
            'l1b2_folder is not specified.'
         PRINT, error_code
         RETURN
      ENDIF
   ENDIF

   ;  Set the pattern of directory names for L1B2 files of the specified
   ;  MISR Mode:
   IF (KEYWORD_SET(l1b2_folder)) THEN BEGIN
      rc = force_path_sep(l1b2_folder, DEBUG = debug, EXCPT_COND = excpt_cond)
      l1b2_path = l1b2_folder
   ENDIF ELSE BEGIN
      l1b2_path = root_dirs[1] + 'P*/L1_' + misr_mode + '/'
   ENDELSE

   ;  Return to the calling routine with an error message if none of the
   ;  expected directories containing these files are not found:
   res = FILE_SEARCH(l1b2_path, COUNT = count)
   IF (debug AND (count EQ 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': No directories match ' + l1b2_path + ' on this computer.'
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Get the information on the availability of MISR L1B2 data files of
   ;  the specified mode:
   rc = avail_l1b2_data(misr_mode, l1b2_path, misr_data, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Handle the case where no MISR data are found:
   IF (misr_data EQ {}) THEN RETURN

   ;  Define the standard location for the output file on this computer:
   IF (KEYWORD_SET(out_folder)) THEN BEGIN
      rc = force_path_sep(out_folder, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      out_fpath = out_folder
   ENDIF ELSE BEGIN
      out_fpath = root_dirs[3] + 'Available' + PATH_SEP() + 'L1B2_' + $
         misr_mode + PATH_SEP()
   ENDELSE

   ;  Check that the output directory 'out_fpath' exists and is writable, and
   ;  if not, create it:
   res = is_writable_dir(out_fpath, /CREATE)
   IF (debug AND (res NE 1)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
         rout_name + ': The directory out_fpath is unwritable.'
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Set the name of the output file:
   out_fname = 'Avail_L1B2_rad_' + misr_mode + '_' + comp_name + $
      '_MISR-Mission_' + date + '.txt'
   out_fspec = out_fpath + out_fname
   fmt1 = '(A30, A)'

   ;  Open the output file:
   OPENW, ounit, out_fspec, /GET_LUN
   PRINTF, ounit, 'File name: ', FILE_BASENAME(out_fspec), $
      FORMAT = fmt1
   PRINTF, ounit, 'Folder name: ', FILE_DIRNAME(out_fspec, /MARK_DIRECTORY), $
      FORMAT = fmt1
   PRINTF, ounit, 'Generated by: ', rout_name, FORMAT = fmt1
   PRINTF, ounit, 'Generated on: ', comp_name, FORMAT = fmt1
   PRINTF, ounit, 'Saved on: ', date_time, FORMAT = fmt1
   PRINTF, ounit

   PRINTF, ounit, 'Content: ', 'MISR L1B2 ' + misr_mode + $
      ' data availability for Version ' + l1b2_version, FORMAT = fmt1
   PRINTF, ounit

   n_dirs = misr_data.NumDirs
   fmt2 = '(A40, 2X, A8, 2X, A8, 2X, A10, 2X, A10)'
   fmt3 = '(A40, 2X, A8, 2X, I8, 2X, A10, 2X, A10)'

   headers = STRARR(5)
   headers[0] = 'Directory names'
   headers[1] = 'Sizes'
   headers[2] = '# files'
   headers[3] = 'From'
   headers[4] = 'To'

   PRINTF, ounit, $
      headers[0], $
      headers[1], $
      headers[2], $
      headers[3], $
      headers[4], $
      FORMAT = fmt2
   PRINTF, ounit, $
      strrepeat('-', STRLEN(headers[0])), $
      strrepeat('-', STRLEN(headers[1])), $
      strrepeat('-', STRLEN(headers[2])), $
      strrepeat('-', STRLEN(headers[3])), $
      strrepeat('-', STRLEN(headers[4])), $
      FORMAT = fmt2

   FOR i = 0, n_dirs - 1 DO BEGIN
      PRINTF, ounit, $
         misr_data.DirNames[i], $
         misr_data.DirSizes[i], $
         misr_data.NumFiles[i], $
         misr_data.IniDate[i], $
         misr_data.FinDate[i], $
         FORMAT = fmt3
   ENDFOR

   CLOSE, ounit

   IF (verbose GT 0) THEN BEGIN
      PRINT, 'The output file'
      PRINT, '   ' + FILE_BASENAME(out_fspec)
      PRINT, 'has been saved in the folder'
      PRINT, '   ' + FILE_DIRNAME(out_fspec)
   ENDIF
   IF (verbose GT 1) THEN PRINT, 'Exiting ' + rout_name + '.'

END
