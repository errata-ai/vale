require 'os'

exe = 'vale'
if OS.windows?
  exe += '.exe'
end
exe += ' --output="line" --sort'

When(/^I lint "(.*)"$/) do |file|
  step %(I cd to "../../fixtures/formats")
  step %(I run `#{exe} #{file}`)
end

When(/^I test "(.*)"$/) do |dir|
  step %(I cd to "../../fixtures/#{dir}")
  step %(I run `#{exe} .`)
end

When(/^I test rule "(.*)"$/) do |name|
  step %(I cd to "../../fixtures/rules/#{name}")
  step %(I run `#{exe} test.txt`)
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
