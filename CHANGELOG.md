# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.0.0](https://github.com/voxpupuli/puppet-poudriere/tree/v2.0.0) (2021-06-15)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/v1.4.0...v2.0.0)

**Breaking changes:**

- Drop EoL Puppet 5 support; Add Puppet 7 [\#63](https://github.com/voxpupuli/puppet-poudriere/pull/63) ([smortex](https://github.com/smortex))
- Sync poudriere.conf template with recent release [\#58](https://github.com/voxpupuli/puppet-poudriere/pull/58) ([smortex](https://github.com/smortex))
- Do not hardcode a default version in poudriere::env [\#57](https://github.com/voxpupuli/puppet-poudriere/pull/57) ([smortex](https://github.com/smortex))
- Use the FreeBSD "central server" for downloads [\#56](https://github.com/voxpupuli/puppet-poudriere/pull/56) ([smortex](https://github.com/smortex))
- Prefer optional non-empty strings [\#53](https://github.com/voxpupuli/puppet-poudriere/pull/53) ([smortex](https://github.com/smortex))

**Implemented enhancements:**

- Switch to EPP templates [\#61](https://github.com/voxpupuli/puppet-poudriere/pull/61) ([smortex](https://github.com/smortex))
- Allow to specify a mountpoint when creating a portstree [\#55](https://github.com/voxpupuli/puppet-poudriere/pull/55) ([smortex](https://github.com/smortex))

**Fixed bugs:**

- Fix portstree detection [\#60](https://github.com/voxpupuli/puppet-poudriere/pull/60) ([smortex](https://github.com/smortex))
- Unbreak poudriere::env::makefile [\#59](https://github.com/voxpupuli/puppet-poudriere/pull/59) ([smortex](https://github.com/smortex))

**Closed issues:**

- Module modernization and cleanup [\#52](https://github.com/voxpupuli/puppet-poudriere/issues/52)

**Merged pull requests:**

- Rework $poudriere::env::arch [\#54](https://github.com/voxpupuli/puppet-poudriere/pull/54) ([smortex](https://github.com/smortex))
- Use data types for all parameters [\#51](https://github.com/voxpupuli/puppet-poudriere/pull/51) ([smortex](https://github.com/smortex))
- modulesync 3.0.0 & puppet-lint updates [\#45](https://github.com/voxpupuli/puppet-poudriere/pull/45) ([bastelfreak](https://github.com/bastelfreak))

## [v1.4.0](https://github.com/voxpupuli/puppet-poudriere/tree/v1.4.0) (2020-04-27)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.3.0...v1.4.0)

**Merged pull requests:**

- Fix author [\#43](https://github.com/voxpupuli/puppet-poudriere/pull/43) ([dhoppe](https://github.com/dhoppe))
- Allow puppetlabs/stdlib 6.x [\#41](https://github.com/voxpupuli/puppet-poudriere/pull/41) ([dhoppe](https://github.com/dhoppe))

## [1.3.0](https://github.com/voxpupuli/puppet-poudriere/tree/1.3.0) (2019-12-28)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.2.1...1.3.0)

**Merged pull requests:**

- Add support for portstree branch [\#39](https://github.com/voxpupuli/puppet-poudriere/pull/39) ([jdmulloy](https://github.com/jdmulloy))
- Fix detection of created jails [\#38](https://github.com/voxpupuli/puppet-poudriere/pull/38) ([jdmulloy](https://github.com/jdmulloy))
- Fix SAVE\_WRKDIR [\#37](https://github.com/voxpupuli/puppet-poudriere/pull/37) ([jdmulloy](https://github.com/jdmulloy))
- Update from xaque208 modulesync\_config [\#36](https://github.com/voxpupuli/puppet-poudriere/pull/36) ([xaque208](https://github.com/xaque208))
- Update from xaque208 modulesync\_config [\#35](https://github.com/voxpupuli/puppet-poudriere/pull/35) ([xaque208](https://github.com/xaque208))

## [1.2.1](https://github.com/voxpupuli/puppet-poudriere/tree/1.2.1) (2019-02-27)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.2.0...1.2.1)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#34](https://github.com/voxpupuli/puppet-poudriere/pull/34) ([xaque208](https://github.com/xaque208))

## [1.2.0](https://github.com/voxpupuli/puppet-poudriere/tree/1.2.0) (2019-02-02)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.1.0...1.2.0)

**Merged pull requests:**

- Updates for new build jail [\#33](https://github.com/voxpupuli/puppet-poudriere/pull/33) ([xaque208](https://github.com/xaque208))

## [1.1.0](https://github.com/voxpupuli/puppet-poudriere/tree/1.1.0) (2018-05-27)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.0.3...1.1.0)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#32](https://github.com/voxpupuli/puppet-poudriere/pull/32) ([xaque208](https://github.com/xaque208))
- modulesync 1.9.0-16-gc46b42a [\#31](https://github.com/voxpupuli/puppet-poudriere/pull/31) ([xaque208](https://github.com/xaque208))

## [1.0.3](https://github.com/voxpupuli/puppet-poudriere/tree/1.0.3) (2018-02-11)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.0.2...1.0.3)

**Closed issues:**

- Still need cron\_enable in init.pp manifest [\#24](https://github.com/voxpupuli/puppet-poudriere/issues/24)

**Merged pull requests:**

- Update from xaque208 modulesync\_config [\#30](https://github.com/voxpupuli/puppet-poudriere/pull/30) ([xaque208](https://github.com/xaque208))
- modulesync 2017-05-03 [\#29](https://github.com/voxpupuli/puppet-poudriere/pull/29) ([xaque208](https://github.com/xaque208))

## [1.0.2](https://github.com/voxpupuli/puppet-poudriere/tree/1.0.2) (2017-01-28)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.0.1...1.0.2)

**Merged pull requests:**

- Drop beaker from Gemfile [\#28](https://github.com/voxpupuli/puppet-poudriere/pull/28) ([xaque208](https://github.com/xaque208))
- Fix ccache option [\#27](https://github.com/voxpupuli/puppet-poudriere/pull/27) ([phyber](https://github.com/phyber))

## [1.0.1](https://github.com/voxpupuli/puppet-poudriere/tree/1.0.1) (2016-04-04)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/1.0.0...1.0.1)

**Merged pull requests:**

- Update testing to include puppet4 [\#26](https://github.com/voxpupuli/puppet-poudriere/pull/26) ([xaque208](https://github.com/xaque208))

## [1.0.0](https://github.com/voxpupuli/puppet-poudriere/tree/1.0.0) (2015-10-19)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.1.5...1.0.0)

**Merged pull requests:**

- rename deprecated parametrs [\#25](https://github.com/voxpupuli/puppet-poudriere/pull/25) ([b4ldr](https://github.com/b4ldr))

## [0.1.5](https://github.com/voxpupuli/puppet-poudriere/tree/0.1.5) (2015-10-08)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.1.4...0.1.5)

**Closed issues:**

- Symlinks not supported [\#21](https://github.com/voxpupuli/puppet-poudriere/issues/21)

**Merged pull requests:**

- add ability to silent cron on success [\#23](https://github.com/voxpupuli/puppet-poudriere/pull/23) ([b4ldr](https://github.com/b4ldr))

## [0.1.4](https://github.com/voxpupuli/puppet-poudriere/tree/0.1.4) (2015-02-08)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.1.3...0.1.4)

**Merged pull requests:**

- Update testing [\#22](https://github.com/voxpupuli/puppet-poudriere/pull/22) ([xaque208](https://github.com/xaque208))
- Syntax fix in README [\#20](https://github.com/voxpupuli/puppet-poudriere/pull/20) ([tbartelmess](https://github.com/tbartelmess))

## [0.1.3](https://github.com/voxpupuli/puppet-poudriere/tree/0.1.3) (2014-11-25)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.1.2...0.1.3)

**Merged pull requests:**

- Testing [\#19](https://github.com/voxpupuli/puppet-poudriere/pull/19) ([xaque208](https://github.com/xaque208))

## [0.1.2](https://github.com/voxpupuli/puppet-poudriere/tree/0.1.2) (2014-11-09)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.1.1...0.1.2)

**Merged pull requests:**

- Begin rspec-puppet tests [\#18](https://github.com/voxpupuli/puppet-poudriere/pull/18) ([xaque208](https://github.com/xaque208))

## [0.1.1](https://github.com/voxpupuli/puppet-poudriere/tree/0.1.1) (2014-10-19)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.1.0...0.1.1)

**Merged pull requests:**

- Import testing from skeleton [\#17](https://github.com/voxpupuli/puppet-poudriere/pull/17) ([xaque208](https://github.com/xaque208))

## [0.1.0](https://github.com/voxpupuli/puppet-poudriere/tree/0.1.0) (2014-07-11)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.9...0.1.0)

**Merged pull requests:**

- support for multiple portstrees [\#16](https://github.com/voxpupuli/puppet-poudriere/pull/16) ([skoef](https://github.com/skoef))

## [0.0.9](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.9) (2014-07-01)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.8...0.0.9)

**Closed issues:**

- latest issue has syntax error [\#12](https://github.com/voxpupuli/puppet-poudriere/issues/12)
- poudriere error: Unknown value for USE\_TMPFS [\#7](https://github.com/voxpupuli/puppet-poudriere/issues/7)
- Add support for package options [\#1](https://github.com/voxpupuli/puppet-poudriere/issues/1)

**Merged pull requests:**

- Cron support [\#15](https://github.com/voxpupuli/puppet-poudriere/pull/15) ([skoef](https://github.com/skoef))
- Addtests [\#14](https://github.com/voxpupuli/puppet-poudriere/pull/14) ([xaque208](https://github.com/xaque208))
- Add tests [\#13](https://github.com/voxpupuli/puppet-poudriere/pull/13) ([xaque208](https://github.com/xaque208))
- Cron support, example for exporting pkgng repo and some cleaning [\#11](https://github.com/voxpupuli/puppet-poudriere/pull/11) ([skoef](https://github.com/skoef))
- make all config file options variables so they can be edited [\#10](https://github.com/voxpupuli/puppet-poudriere/pull/10) ([sethlyons](https://github.com/sethlyons))
- Update tmpfs setting for \#7 [\#8](https://github.com/voxpupuli/puppet-poudriere/pull/8) ([xaque208](https://github.com/xaque208))
- Base Folder/tmpfs [\#6](https://github.com/voxpupuli/puppet-poudriere/pull/6) ([DJClean](https://github.com/DJClean))
- Add proxy ability [\#5](https://github.com/voxpupuli/puppet-poudriere/pull/5) ([DJClean](https://github.com/DJClean))

## [0.0.8](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.8) (2014-01-11)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.7...0.0.8)

**Merged pull requests:**

- add support for package-specific make options through pkg\_makeopts [\#4](https://github.com/voxpupuli/puppet-poudriere/pull/4) ([lifeforms](https://github.com/lifeforms))
- allow NO\_ZFS by setting zpool to false or '' [\#3](https://github.com/voxpupuli/puppet-poudriere/pull/3) ([lifeforms](https://github.com/lifeforms))
- fetch ports by svn: portsnap does not allow non-interactive use [\#2](https://github.com/voxpupuli/puppet-poudriere/pull/2) ([lifeforms](https://github.com/lifeforms))

## [0.0.7](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.7) (2013-02-07)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.6...0.0.7)

## [0.0.6](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.6) (2013-02-07)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.5...0.0.6)

## [0.0.5](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.5) (2013-02-05)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.4...0.0.5)

## [0.0.4](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.4) (2012-12-20)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/0.0.1...0.0.4)

## [0.0.1](https://github.com/voxpupuli/puppet-poudriere/tree/0.0.1) (2012-10-16)

[Full Changelog](https://github.com/voxpupuli/puppet-poudriere/compare/3227b80ce97c4e901eda3bb6b75c5ac04ea72766...0.0.1)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
