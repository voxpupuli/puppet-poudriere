# @summary A supported tmpfs setting for poudriere
type Poudriere::Tmpfs = Variant[
  Enum[
    'all',
    'no',
    'yes',
  ],
  Array[
    Enum[
      'data',
      'localbase',
      'wrkdir',
    ],
  ],
]
