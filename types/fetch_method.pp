# @summary A supported fetch method for poudriere
type Poudriere::Fetch_method = Enum[
  'git',
  'git+http',
  'git+https',
  'git+ssh',
  'null',
  'portsnap',
  'svn',
  'svn+file',
  'svn+http',
  'svn+https',
  'svn+ssh',
]
