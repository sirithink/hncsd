#coding: utf-8
require 'mechanize'

class Agent
  class << self
    def fetch_form
      agent = get_agent
      page = agent.get('http://www.hncsjj.gov.cn/QueryJDCWZOther.aspx')
      form = page.forms.first
      fields = {}
      form.fields.each do |field|
        fields[field.name] = field.value if field.is_a? Mechanize::Form::Hidden
      end
      fields['hncsjj_session'] = dump_session(agent)
      fields
    end

    def fetch_captcha(hncsjj_session)
      agent = get_agent
      load_session(agent, hncsjj_session)
      captcha = agent.get('http://www.hncsjj.gov.cn/ValidateCode.aspx')
      captcha.body_io
    end

    def post_form(fields, hncsjj_session)
      agent = get_agent
      load_session(agent, hncsjj_session)

      agent.post('http://www.hncsjj.gov.cn/QueryJDCWZOther.aspx', fields)
    end

    private
    def get_agent
      agent = Mechanize.new
      agent.user_agent_alias=('Mac Safari')
      agent
    end
    def dump_session(agent)
      cookie = nil; sio = StringIO.new
      agent.cookie_jar.dump_cookiestxt(sio)
      sio.rewind
      cookie = sio.read
      sio.close
      Base64.encode64(cookie).strip
    end

    def load_session(agent, hncsjj_session)
      cookie_jar = Mechanize::CookieJar.new
      cookie_jar.load_cookiestxt( Base64.decode64(hncsjj_session) )
      agent.cookie_jar = cookie_jar
    end
  end
end
