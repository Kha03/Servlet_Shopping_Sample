package impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import dao.ProductDao;
import model.Product;

public class ProductImpl implements ProductDao {
	private DataSource datasource;

	public ProductImpl(DataSource datasource) {
		this.datasource = datasource;
	}

	@Override
	public List<Product> findAll() {
		String sql = "SELECT * FROM product";
		List<Product> products = new ArrayList<Product>();
		try (Connection connection = this.datasource.getConnection();
				PreparedStatement pStatement = connection.prepareStatement(sql);
				ResultSet rSet = pStatement.executeQuery();) {
			while (rSet.next()) {
				int id = rSet.getInt("id");
				String name = rSet.getString("name");
				Double price = rSet.getDouble("price");
				String image = rSet.getString("image");
				System.out.println(id + " " + name + " " + price + " " + image);
				products.add(new Product(id, name, id, image));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return products;
	}

	@Override
	public Product getById(int id) {
		String sql = "SELECT * FROM product WHERE id=?";
		Product product = new Product();
		try (Connection connection = this.datasource.getConnection();
				PreparedStatement pStatement = connection.prepareStatement(sql);) {
			pStatement.setInt(1, id);
			try (ResultSet rSet = pStatement.executeQuery();) {
				while (rSet.next()) {
					product.setId(rSet.getInt("id"));
					product.setName(rSet.getString("name"));
					product.setPrice(rSet.getFloat("price"));
					product.setImage(rSet.getString("image"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return product;
	}

}
