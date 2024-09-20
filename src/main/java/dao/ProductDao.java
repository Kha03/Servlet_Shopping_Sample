package dao;

import java.util.List;

import model.Product;


public interface ProductDao {
	public List<model.Product> findAll();
	public Product getById(int id);
}
