require 'spec_helper'

module ChannelAdvisor
  module Services
    describe InventoryService do
      describe ".ping" do
        use_vcr_cassette "responses/inventory_service/ping", :allow_playback_repeats => true

        before(:each) do
          @last_request, @last_response = nil

          InventoryService.client.config.hooks.define(:ping, :soap_request) do |callback, request|
            @last_request = request.http
            @last_response = callback.call
          end
        end

        it "sends a valid SOAP request" do
          InventoryService.ping
          @last_request.should match_valid_xml_body_for :ping
        end

        it "returns a SOAP response" do
          soap_response = InventoryService.ping
          soap_response.should be_a Savon::SOAP::Response
        end
      end # .ping

      describe ".update_inventory_item_quantity_and_price" do
        use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price", :allow_playback_repeats => true

        let(:item) do
          {
            :sku => "FAKE001",
            :quantity_info => {
              :update_type  => "Absolute",
              :total        => 5000
            },
            :price_info => {
              :cost                       => 2.99,
              :retail_price               => 11.99,
              :starting_price             => 5.99,
              :reserve_price              => 7.99,
              :take_it_price              => 9.99,
              :second_chance_offer_price  => 8.99,
              :store_price                => 9.49
            }
          }
        end

        before(:each) do
          @last_request, @last_response = nil

          InventoryService.client.config.hooks.define(:update_inventory_item_quantity_and_price, :soap_request) do |callback, request|
            @last_request = request.http
            @last_response = callback.call
          end
        end

        it "returns a SOAP response" do
          soap_response = InventoryService.update_inventory_item_quantity_and_price(item)
          soap_response.should be_a Savon::SOAP::Response
        end # returns a SOAP response

        context "with only quantity info" do
          use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price/quantity_only"

          it "sends a valid SOAP request with only quantity info" do
            item.delete(:price_info)
            InventoryService.update_inventory_item_quantity_and_price(item)
            @last_request.should match_valid_xml_body_for :update_item_quantity
          end
        end # with only quantity info

        context "with only price info" do
          use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price/price_only"

          it "sends a valid SOAP request with only price info" do
            item.delete(:quantity_info)
            InventoryService.update_inventory_item_quantity_and_price(item)
            @last_request.should match_valid_xml_body_for :update_item_price
          end
        end # with only price info

        context "with both quantity and price info" do
          use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price/quantity_and_price"

          it "sends a valid SOAP request with both quantity and price info" do
            InventoryService.update_inventory_item_quantity_and_price(item)
            @last_request.should match_valid_xml_body_for :update_item_quantity_and_price
          end
        end # with both quantity and price info
      end # .update_inventory_item_quantity_and_price

      describe ".update_inventory_item_quantity_and_price_list" do
        use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list", :allow_playback_repeats => true

        let(:item1) do
          {
            :sku => "FAKE001",
            :quantity_info => {
              :update_type  => "Absolute",
              :total        => 5000
            },
            :price_info => {
              :cost                       => 2.99,
              :retail_price               => 11.99,
              :starting_price             => 5.99,
              :reserve_price              => 7.99,
              :take_it_price              => 9.99,
              :second_chance_offer_price  => 8.99,
              :store_price                => 9.49
            }
          }
        end

        let(:item2) do
          {
            :sku => "FAKE002",
            :quantity_info => {
              :update_type  => "Absolute",
              :total        => 7500
            },
            :price_info => {
              :cost                       => 3.99,
              :retail_price               => 10.99,
              :starting_price             => 4.99,
              :reserve_price              => 7.99,
              :take_it_price              => 8.99,
              :second_chance_offer_price  => 6.99,
              :store_price                => 8.49
            }
          }
        end

        before(:each) do
          @last_request, @last_response = nil

          InventoryService.client.config.hooks.define(:update_inventory_item_quantity_and_price_list, :soap_request) do |callback, request|
            @last_request = request.http
            @last_response = callback.call
          end
        end

        it "returns a SOAP response" do
          soap_response = InventoryService.update_inventory_item_quantity_and_price_list([item1])
          soap_response.should be_a Savon::SOAP::Response
        end # returns a SOAP response

        context "with one item" do
          context "with only quantity info" do
            use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list/with_one_item/quantity_only"

            it "sends a valid SOAP request with only quantity info" do
              item1.delete(:price_info)
              InventoryService.update_inventory_item_quantity_and_price_list([item1])
              @last_request.should match_valid_xml_body_for "update_inventory_item_quantity_and_price_list/with_one_item/quantity_only"
            end
          end # with only quantity info

          context "with only price info" do
            use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list/with_one_item/price_only"

            it "sends a valid SOAP request with only price info" do
              item1.delete(:quantity_info)
              InventoryService.update_inventory_item_quantity_and_price_list([item1])
              @last_request.should match_valid_xml_body_for "update_inventory_item_quantity_and_price_list/with_one_item/price_only"
            end
          end # with only price info

          context "with both quantity and price info" do
            use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list/with_one_item/quantity_and_price"

            it "sends a valid SOAP request with both quantity and price info" do
              InventoryService.update_inventory_item_quantity_and_price_list([item1])
              @last_request.should match_valid_xml_body_for "update_inventory_item_quantity_and_price_list/with_one_item/quantity_and_price"
            end
          end # with both quantity and price info
        end # with one item

        context "with two items" do
          context "with only quantity info" do
            use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list/with_two_items/quantity_only"

            it "sends a valid SOAP request with only quantity info" do
              item1.delete(:price_info)
              item2.delete(:price_info)
              InventoryService.update_inventory_item_quantity_and_price_list([item1, item2])
              @last_request.should match_valid_xml_body_for "update_inventory_item_quantity_and_price_list/with_two_items/quantity_only"
            end
          end # with only quantity info

          context "with only price info" do
            use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list/with_two_items/price_only"

            it "sends a valid SOAP request with only price info" do
              item1.delete(:quantity_info)
              item2.delete(:quantity_info)
              InventoryService.update_inventory_item_quantity_and_price_list([item1, item2])
              @last_request.should match_valid_xml_body_for "update_inventory_item_quantity_and_price_list/with_two_items/price_only"
            end
          end # with only price info

          context "with both quantity and price info" do
            use_vcr_cassette "responses/inventory_service/update_inventory_item_quantity_and_price_list/with_two_items/quantity_and_price"

            it "sends a valid SOAP request with both quantity and price info" do
              InventoryService.update_inventory_item_quantity_and_price_list([item1, item2])
              @last_request.should match_valid_xml_body_for "update_inventory_item_quantity_and_price_list/with_two_items/quantity_and_price"
            end
          end # with both quantity and price info
        end # with two items
      end # .update_inventory_item_quantity_and_price_list

      describe ".sync_inventory_item" do
        use_vcr_cassette "responses/inventory_service/sync_inventory_item", :allow_playback_repeats => true

        let(:item) do
          {
            :sku => "FAKE001",
            :title => "Just a fake item",
            :subtitle => "It's really fake",
            :short_description => "So fake, doesn't need a description",
            :description => "It's faker, then the fakest of fakiestest (that word is fake..)",
            :weight => 15,
            :supplier_code => nil, #will fail if supplier doesn't exist
            :warehouse_location => "Isle 13, Shelf 12, Bin 10",
            :tax_product_code => "OR",
            :flag_style => "NoFlag",
            :flag_description => nil, #no flag set,
            :asin => "123098",
            :isbn => "65465",
            :upc => "51919819",
            :mpn => "980988",
            :ean => "65461508",
            :manufacturer => "Fake Products, Inc",
            :brand => "Fake",
            :condition => "New",
            :warranty => "None!",
            :product_margin => 200,
            :supplier_po => "ABC-123",
            :received_in_inventory => DateTime.now,
            :harmonized_code => "AA",
            :height => 2,
            :length => 2,
            :width => 2,
            :classification => "Awesome" ,
            :meta_description => "Blah blah blah",
            :store_info => {
              :display_in_store => true,
              :title => "Just a fake item",
              :description => "It's faker, then the fakest of fakiestest (that word is fake..)",
              :category_id => nil #fails if category doesn't exist
            },
            :quantity_info => {
              :update_type  => "Absolute",
              :total        => 5000
            },
            :price_info => {
              :cost                       => 2.99,
              :retail_price               => 11.99,
              :starting_price             => 5.99,
              :reserve_price              => 7.99,
              :take_it_price              => 9.99,
              :second_chance_offer_price  => 8.99,
              :store_price                => 9.49
            }
          }
        end

        before(:each) do
          @last_request, @last_response = nil   
          InventoryService.client.config.hooks.define(:sync_inventory_item, :soap_request) do |callback, request|
            @last_request = request.http
            @last_response = callback.call
          end
        end

        it "returns a SOAP response" do
          soap_response = InventoryService.sync_inventory_item(item)
          soap_response.should be_a Savon::SOAP::Response
        end # returns a SOAP response      
      end #describe
    end # InventoryService
  end # Services
end # ChannelAdvisor