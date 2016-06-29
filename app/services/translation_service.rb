class TranslationService
  class InvalidLocale < RuntimeError; end

  def initialize(locales = I18n.available_locales)
    @available_locales = locales.map(&:to_s)
  end

  def locale_for(lang)
    faile InvalidLocale, "#{lang} is not supported" unless valid_locale?(lang.to_s)

    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    I18n.backend.send(:translations)[lang.to_sym]
  end

  def json
    Hash[@available_locales.map{ |lang| [lang.to_sym, locale_for(lang)] }].to_json
  end

  private

  def valid_locale?(lang)
    @available_locales.include?(lang)
  end
end
