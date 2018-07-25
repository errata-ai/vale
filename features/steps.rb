require 'os'

exe = 'vale'
if OS.windows?
  exe += '.exe'
end
exe += ' --output=line --sort --normalize --relative'

When(/^I lint "(.*)"$/) do |file|
  step %(I cd to "../../fixtures/formats")
  step %(I run `#{exe} #{file}`)
end

When(/^I lint with config "(.*)"$/) do |file|
  step %(I cd to "../../fixtures/formats")
  step %(I run `#{exe} --config='#{file}' test.md`)
end

When(/^I test "(.*)"$/) do |dir|
  step %(I cd to "../../fixtures/#{dir}")
  step %(I run `#{exe} .`)
end

When(/^I test comments for "(.*)"$/) do |ext|
  step %(I cd to "../../fixtures/comments")
  step %(I run `#{exe} test#{ext}`)
end

When(/^I test patterns for "(.*)"$/) do |file|
  step %(I cd to "../../fixtures/patterns")
  step %(I run `#{exe} #{file}`)
end

When(/^I test scope "(.*)"$/) do |scope|
  step %(I cd to "../../fixtures/scopes/#{scope}")
  step %(I run `#{exe} .`)
end

When(/^I apply style "(.*)"$/) do |style|
  step %(I cd to "../../fixtures/styles/#{style}")
  step %(I run `#{exe} .`)
end

When(/^I run vale "(.*)"$/) do |file|
  step %(I run `#{exe} #{file}`)
end

When(/^I test glob "(.*)"$/) do |glob|
  step %(I cd to "../../fixtures/formats")
  step %(I run `#{exe} --glob='#{glob}' .`)
end

When(/^I run cat "([^\s]+)" "([^\s]+)"$/) do |file, ext|
  step %(I cd to "../../fixtures/formats")
  if OS.windows?
    step %(I run `PowerShell -Command Get-Content #{file} | #{exe} --ext='#{ext}'`)
  else
    step %(I run `bash -c 'cat #{file} | #{exe} --ext="#{ext}"'`)
  end
end

When(/^I lint string "(.*)"$/) do |string|
  step %(I cd to "../../fixtures/formats")
  if OS.windows?
    # FIXME: How do we pass a string with spaces on AppVeyor?
    step %(I run `#{exe} "#{string}"`)
  else
    step %(I run `#{exe} '#{string}'`)
  end
end
