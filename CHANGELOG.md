## [0.1.6] - 2019-08-02

### Breaking Changes
  - Changed initializer, recommended to regenerate it. Database options
    names are changed to more closely match Rails.

### Added
  - Feature: `skip_download` option. This option is false by default. Changing
    it to true means that the data file will be available and loaded locally.
    Refer to the example app [^1] for a working example of this.

    [^1]: https://github.com/andyatkinson/rails-with-seedster


## [0.1.5] - 2019-07-16

### Added
  - Feature: Rails initializer. Run with `rails generate seedster:initializer`

