RSpec.describe "RSMP site commands" do
  it 'responds to valid command request' do
    TestSite.connected do |task,supervisor,site|
      # TODO
      # compoments should be read from a config, or fetched from the site
      # list of commands and parameters should be read from an SXL specification (in JSON Schema?)
      component = 'AA+BBCCC=DDDEE002'
      command_code = 'MA104'
      command_name = 'message'

      [
        "Rainbows!",
        198234,
        -198234,
        0.0523,
        -0.0523,
        '.0123',
        '-.0123',
        "æåøÆÅØ",
        "\/\"\'\f\t\r",
        "-_,.-/*§!{#€%&()=?`}[]<>:;",
        " ",
        ""
      ].each do |value|
        site.send_command 'AA+BBCCC=DDDEE002', [{"cCI":command_code,"n":command_name,"cO":"","v":value}]
        response = site.wait_for_command_response component: 'AA+BBCCC=DDDEE002', timeout: 1
        expect(response).to be_a(RSMP::CommandResponse)
        expect(response.attributes["cId"]).to eq("AA+BBCCC=DDDEE002")
        expect(response.attributes["rvs"]).to eq([{"age"=>"recent", "cCI"=>command_code, "n"=>command_name, "v"=>value}])
      end
    end
  end
end
