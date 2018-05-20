PRO avail_l1b2, misr_mode, DEBUG = debug, EXCPT_COND = excpt_cond

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
   ;  information in a log file. Input and output files are assumed to be
   ;  in the standard locations defined by the function set_root_dirs.pro.
   ;
   ;  SYNTAX: avail_l1b2_gm, misr_mode, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_mode {STRING} [I]: A 2-character parameter indicating
   ;      whether to report on the availability of Global (GM) or Local
   ;      (LM) Mode files.
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
   ;  *   If no exception condition has been detected, the keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call. An output
   ;      file named avail_L1B2_[hostname]_[creation_date].txt and located
   ;      in the folder root_dirs[3] + ’/Available/L1B2_’ + misr_mode
   ;      contains information on the availability of MISR L1B2 files of
   ;      the specified MODE in the folders of root_dirs[1] on the current
   ;      computer hostname at the time of execution [creation_date].
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
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter misr_mode is invalid.
   ;
   ;  *   Error 199: Unrecognized computer: Update the function
   ;      set_root_dirs.
   ;
   ;  *   Error 400: No directories containing MISR L1B2 files of the
   ;      specified MODE have been found at the expected locations on this
   ;      computer.
   ;
   ;  *   Error 410: An exception condition occurred in
   ;      avail_l1b2_data.pro.
   ;
   ;  *   Error 500: An exception condition occurred in is_writable.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   avail_l1b2_data.pro
   ;
   ;  *   chk_misr_mode.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   today.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function works equally well with GM and LM files.
   ;
   ;  *   NOTE 2: This program currently reports on the first and last
   ;      MISR L1B2 data files of the specified MODE found in standard
   ;      places on this computer. It does not verify the availability of
   ;      all 9 L1B2 files per ORBIT, or of the associated Geometric
   ;      Parameters and L2 Land Surface files, which are also required by
   ;      the MISR-HR processing system. Nor does it report on the version
   ;      status of the data files.
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
   ;      IDL> avail_l1b2, 'GM', /DEBUG, EXCPT_COND = excpt_cond
   ;      The output file
   ;      avail_L1B2GM_MicMac2_2018-05-04.txt
   ;      has been created in the folder
   ;      ~/MISR_HR/Outcomes/Available/L1B2_GM
   ;      IDL> SPAWN, 'cat ~/MISR_HR/Outcomes/Available/L1B2_GM/
   ;         avail_L1B2GM_MicMac2_2018-05-04.txt'
   ;           File name: 'avail_L1B2GM_MicMac2_2018-05-04.txt'
   ;         Folder name: root_dirs[3] + 'Available/L1B2_GM/'
   ;        Generated by: AVAIL_L1B2
   ;            Saved on: 2018-05-04
   ;
   ;      Content: MISR L1B2 GM data availability on computer MicMac2.
   ;
   ;                      Directory names Sizes # files       From         To
   ;                      --------------- ----- -------       ----         --
   ;      /Volumes/MISR_Data3/P168/L1_GM/  615G    3483 2000-03-24 2017-11-18
   ;      /Volumes/MISR_Data3/P169/L1_GM/  560G    3159 2000-02-28 2015-11-20
   ;      /Volumes/MISR_Data3/P170/L1_GM/  558G    3177 2000-03-06 2015-11-27
   ;      /Volumes/MISR_Data3/P171/L1_GM/  546G    3137 2000-02-26 2015-11-18
   ;      /Volumes/MISR_Data3/P176/L1_GM/  542G    3150 2000-02-29 2015-11-21
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–24: Version 0.8 — Initial release, under the name
   ;      avail_l1b2_gm.pro.
   ;
   ;  *   2017–12–18: Version 0.9 — Update Output format.
   ;
   ;  *   2018–01–30: Version 1.0 — Initial public release.
   ;
   ;  *   2018–04–08: Version 1.1 — Update this function to use
   ;      set_root_dirs.pro instead of set_misr_roots.pro.
   ;
   ;  *   2018–05–03: Version 1.2 — Merge this function with its twin
   ;      avail_l1b2_lm.pro and change the name to avail_l1b2.pro.
   ;
   ;  *   2018–05–14: Version 1.3 — Update this function to use the
   ;      revised version of is_writable.pro and update the documentation.
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

   ;  Get the current date:
   date = today(FMT = 'ymd')
   date_time = today(FMT = 'nice')

   ;  Set the pattern of directory names for L1B2 files of the specified
   ;  MISR Mode:
   pat_dir = root_dirs[1] + 'P*/L1_' + misr_mode + '/'

   ;  Return to the calling routine with an error message if the expected
   ;  directories containing these files are not found:
   res = FILE_SEARCH(pat_dir, COUNT = count)
   IF ((debug) AND (count EQ 0)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': No directories match ' + pat_dir + ' on this computer.'
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Get the information on the availability of MISR L1B2 data files of
   ;  the specified mode:
   rc = avail_l1b2_data(misr_mode, pat_dir, misr_data, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 410
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      PRINT, excpt_cond
      RETURN
   ENDIF

   ;  Define the standard location for the output file on this computer:
   local_out_dir = 'Available/L1B2_' + misr_mode + '/'
   out_dir = root_dirs[3] + local_out_dir

   ;  Return to the calling routine with an error message if the output
   ;  directory 'out_path' is not writable, and create it if it does not
   ;  exist:
   rc = is_writable(out_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF ((debug) AND ((rc EQ 0) OR (rc EQ -1))) THEN BEGIN
      error_code = 500
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF (rc EQ -2) THEN FILE_MKDIR, out_path

   ;  Set the name of the output file:
   out_name = 'avail_L1B2' + misr_mode + '_' + computer + '_' + date + '.txt'
   out_spec = out_dir + out_name
   fmt1 = '(A30, A)'

   ;  Open the output file:
   OPENW, ounit, out_spec, /GET_LUN
   PRINTF, ounit, "File name: ", "'" + FILE_BASENAME(log_fspec) + "'", $
      FORMAT = fmt1
   PRINTF, ounit, "Folder name: ", "'" + FILE_DIRNAME(log_fspec, $
      /MARK_DIRECTORY) + "'", FORMAT = fmt1
   PRINTF, ounit, 'Generated by: ', rout_name, FORMAT = fmt1
   PRINTF, ounit, 'Generated on: ', computer, FORMAT = fmt1
   PRINTF, ounit, 'Saved on: ', date_time, FORMAT = fmt1
   PRINTF, ounit

   PRINTF, ounit, 'Content: ', 'MISR L1B2 ' + misr_mode + $
      ' data availability on computer ' + computer + '.', FORMAT = fmt1
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
   PRINT, 'The output file'
   PRINT, FILE_BASENAME(out_spec)
   PRINT, 'has been created in the folder'
   PRINT, FILE_DIRNAME(out_spec)

END
