# @summary Parameters to configure Poudriere's cron resources
type Poudriere::Cron_interval = Struct[
  {
    minute   => Optional[Variant[Integer, String]],
    hour     => Optional[Variant[Integer, String]],
    monthday => Optional[String],
    month    => Optional[String],
    week     => Optional[String],
    weekday  => Optional[String],
  }
]
