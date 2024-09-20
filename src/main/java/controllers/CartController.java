package controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import dao.ProductDao;
import impl.ProductImpl;
import jakarta.annotation.Resource;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ItemCart;

/**
 * Servlet implementation class CartController
 */
@WebServlet(urlPatterns = { "/cart", "/cart/*" })
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@Resource(name = "jdbc/shopping_sample")
	private DataSource dataSource;

	private ProductDao productDAO;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CartController() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		super.init(config);
		try {
			System.out.println(dataSource.getConnection());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		productDAO = new ProductImpl(this.dataSource);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action") != null ? request.getParameter("action") : "view";
		switch (action) {
		case "buy":
			doGetBuy(request, response);
			break;
		case "remove":
			 doGetRemove(request, response);
			break;
		case "update":
			// doGetUpdate(request, response);
			break;
		default:
			doGetView(request, response);
			break;
		}
	}

	private void doGetView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("views/cart/index.jsp").forward(request, response);
	}

	private void doGetBuy(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		List<ItemCart> itemCarts = (ArrayList<ItemCart>) session.getAttribute("cartItems");
		if (itemCarts == null) {
			itemCarts = new ArrayList<ItemCart>();
		}
		int id = Integer.parseInt(request.getParameter("id"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		int index = isExisting(id, itemCarts);
		if (index == -1) {
			itemCarts.add(new ItemCart(productDAO.getById(id), quantity));
		} else {
			int quantityInCart = itemCarts.get(index).getQuantity() + quantity;
			itemCarts.get(index).setQuantity(quantityInCart);
		}
		session.setAttribute("cartItems", itemCarts);
		response.sendRedirect("cart");
	}

	private void doGetRemove(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		List<ItemCart> itemCarts = (ArrayList<ItemCart>) session.getAttribute("cartItems");
		int id = Integer.parseInt(request.getParameter("id"));
		int index = isExisting(id, itemCarts);
		itemCarts.remove(index);
		session.setAttribute("cartItems", itemCarts);
		response.sendRedirect("cart");
	}
	private int isExisting(int id, List<ItemCart> itemCarts) {
		for (int i = 0; i < itemCarts.size(); i++) {
			if (itemCarts.get(i).getProduct().getId() == id) {
				return i;
			}
		}
		return -1;
	}
}
