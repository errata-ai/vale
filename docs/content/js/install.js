const groups = [
      {
        id: 'package',
        title: 'Package Manager',
        options: [
          {id: 'brew', title: 'Homebrew', checked: true},
          {id: 'snap', title: 'Snapcraft'},
          {id: 'go', title: 'Go'}
        ]
      },
]

if ($('#quickstart').length) {
  const qs = new Quickstart('#quickstart', groups)
}
