const groups = [{
  id: 'package',
  title: 'Package Manager',
  options: [
    {id: 'brew', title: 'Homebrew', checked: true}, {id: 'go', title: 'Go'},
    {id: 'docker', title: 'Docker'}, {id: 'goreleaser', title: 'GoReleaser'}
  ]
}]

    if ($('#quickstart').length) {
  const qs = new Quickstart('#quickstart', groups)
}
