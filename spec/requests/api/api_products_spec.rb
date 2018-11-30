require 'rails_helper'

RSpec.describe "Api::Products", type: :request do
  before do
    # Create the products
    supplier = Supplier.create!(name: "Amazon", email: "amazon@email.com", phone_number: "234234324")
    Product.create!(supplier_id: supplier.id, name: "WNYX Mug", price: 2, description: "Get your morning news once you wake up with a cup of joe from... well Joe. He made it with his homemade duct tape")
    Product.create!(supplier_id: supplier.id, name: "Hitchhiker's Guide to the Galaxy", price: 42, description: "In many of the more relaxed civilizations on the Outer Eastern Rim of the Galaxy, the Hitch-Hiker's Guide has already supplanted the great Encyclopaedia Galactica as the standard repository of all knowledge and wisdom, for though it has many omissions and contains much that is apocryphal, or at least wildly inaccurate, it scores over the older, more pedestrian work in two important respects. First, it is slightly cheaper; and secondly it has the words DON'T PANIC inscribed in large friendly letters on its cover.")
    Product.create!(supplier_id: supplier.id, name: "Lightsaber", price: 270, description: "Part laser, part samuri sword, all awesome. The lightsaber is an elogant weapon for a more civilized age, not nearly as clumsy as a blaster")
    # Create the jwt
    user = User.create!(name: "Test", email: "test@email.com", password: "password", admin: true)
    post "/api/sessions", params: {email: user.email, password: user.password}
    @jwt = JSON.parse(response.body)["jwt"]
  end

  describe "GET /api/products" do
    it "returns an array of products" do
      get "/api/products"
      products = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(products[0]).to have_key("name")
      expect(products[0]).to have_key("price")
      expect(products[0]).to have_key("images")
      expect(products[0]).to have_key("description")
      expect(products[0]).to have_key("is_discounted?")
      expect(products[0]).to have_key("sales_tax")
      expect(products[0]).to have_key("sales_total")
      expect(products[0]).to have_key("supplier")
      expect(products[0]).to have_key("categories")
    end
  end

  describe "POST /api/products" do
    it "creates a product" do
      post "/api/products",
        params: {
          name: "New name",
          price: 10,
          description: "Test description",
          supplier_id: Supplier.first.id
        },
        headers: {"Authorization": "Bearer #{@jwt}"}
      product = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(product).to have_key("name")
      expect(product).to have_key("price")
      expect(product).to have_key("images")
      expect(product).to have_key("description")
      expect(product).to have_key("is_discounted?")
      expect(product).to have_key("sales_tax")
      expect(product).to have_key("sales_total")
      expect(product).to have_key("supplier")
      expect(product).to have_key("categories")
    end

    it "returns an unauthorized status code without a JWT" do
      post "/api/products", params: {}
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns an error status code with invalid data" do
      post "/api/products", params: {}, headers: {"Authorization": "Bearer #{@jwt}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/products/:id" do
    it "returns the proper attributes" do
      id = Product.first.id
      get "/api/products/#{id}"
      product = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(product).to have_key("name")
      expect(product).to have_key("price")
      expect(product).to have_key("images")
      expect(product).to have_key("description")
      expect(product).to have_key("is_discounted?")
      expect(product).to have_key("sales_tax")
      expect(product).to have_key("sales_total")
      expect(product).to have_key("supplier")
      expect(product).to have_key("categories")
    end
  end

  describe "PATCH /products/:id" do
    it "updates a product" do
      id = Product.first.id
      patch "/api/products/#{id}",
        params: {name: "Updated name"},
        headers: {"Authorization": "Bearer #{@jwt}"}
      product = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(product["name"]).to eq("Updated name")
    end

    it "returns an unauthorized status code without a JWT" do
      id = Product.first.id
      patch "/api/products/#{id}", params: {}
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns an error status code with invalid data" do
      id = Product.first.id
      patch "/api/products/#{id}", params: {name: ""}, headers: {"Authorization": "Bearer #{@jwt}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /products/:id" do
    it "deletes a product" do
      id = Product.first.id
      delete "/api/products/#{id}", headers: {"Authorization": "Bearer #{@jwt}"}
      expect(Product.count).to eq(2)
    end

    it "returns an unauthorized status code without a JWT" do
      id = Product.first.id
      delete "/api/products/#{id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
