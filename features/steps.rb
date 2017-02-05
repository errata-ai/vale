require 'os'

exe = 'txtlint'
if OS.windows?
  exe += '.exe'
end

When(/^I lint "(.*)"$/) do |file|
  step %(I cd to "../../fixtures/formats")
  step %(I run `#{exe} #{file}`)
end

When(/^I test "(.*)"$/) do |check|
  step %(I cd to "../../fixtures/checks/#{check}")
  step %(I run `#{exe} .`)
end

When(/^I apply style "(.*)"$/) do |style|
  step %(I cd to "../../fixtures/styles/#{style}")
  step %(I run `#{exe} .`)
end

When(/^I run txtlint "(.*)"$/) do |file|
  step %(I run `#{exe} #{file}`)
end
