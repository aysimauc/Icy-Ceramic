using ICYCeramic.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace ICYCeramic.Api.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(
        DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<Category> Categories { get; set; }

    public DbSet<Product> Products { get; set; }

    public DbSet<User> Users { get; set; }

    public DbSet<Order> Orders { get; set; }

    public DbSet<OrderItem> OrderItems { get; set; }

    public DbSet<StockMovement> StockMovements { get; set; }

    public DbSet<Favorite> Favorites { get; set; }

    public DbSet<CartItem> CartItems { get; set; }

    protected override void OnModelCreating(
        ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ============================================================
        // CATEGORY
        // ============================================================

        modelBuilder.Entity<Category>(entity =>
        {
            entity.ToTable("Categories");

            entity.HasKey(category => category.Id);

            entity.Property(category => category.Name)
                .IsRequired()
                .HasMaxLength(100);

            entity.Property(category => category.Image)
                .HasMaxLength(500);
        });

        // ============================================================
        // PRODUCT
        // ============================================================

        modelBuilder.Entity<Product>(entity =>
        {
            entity.ToTable("Products");

            entity.HasKey(product => product.Id);

            entity.Property(product => product.Name)
                .IsRequired()
                .HasMaxLength(200);

            entity.Property(product => product.Price)
                .HasColumnType("decimal(18,2)");

            entity.Property(product => product.Image)
                .IsRequired()
                .HasMaxLength(500);

            entity.Property(product => product.Description)
                .IsRequired();

            entity.Property(product => product.Stock)
                .IsRequired();

            entity.HasOne(product => product.Category)
                .WithMany(category => category.Products)
                .HasForeignKey(product => product.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // ============================================================
        // USER
        // ============================================================

        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users");

            entity.HasKey(user => user.Id);

            entity.Property(user => user.Name)
                .IsRequired()
                .HasMaxLength(150);

            entity.Property(user => user.Email)
                .IsRequired()
                .HasMaxLength(200);

            entity.HasIndex(user => user.Email)
                .IsUnique();

            entity.Property(user => user.PasswordHash)
                .IsRequired()
                .HasMaxLength(500);

            entity.Property(user => user.CreatedAt)
                .IsRequired();
        });

        // ============================================================
        // ORDER
        // ============================================================

        modelBuilder.Entity<Order>(entity =>
        {
            entity.ToTable("Orders");

            entity.HasKey(order => order.Id);

            entity.Property(order => order.OrderNumber)
                .IsRequired()
                .HasMaxLength(50);

            entity.HasIndex(order => order.OrderNumber)
                .IsUnique();

            entity.Property(order => order.Total)
                .HasColumnType("decimal(18,2)");

            entity.Property(order => order.PaymentMethod)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(order => order.Address)
                .IsRequired()
                .HasMaxLength(1000);

            entity.Property(order => order.Status)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(order => order.TrackingNumber)
                .HasMaxLength(100);

            entity.Property(order => order.CargoCompany)
                .HasMaxLength(100);

            entity.Property(order => order.CreatedAt)
                .IsRequired();

            entity.HasOne(order => order.User)
                .WithMany()
                .HasForeignKey(order => order.UserId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // ============================================================
        // ORDER ITEM
        // ============================================================

        modelBuilder.Entity<OrderItem>(entity =>
        {
            entity.ToTable("OrderItems");

            entity.HasKey(item => item.Id);

            entity.Property(item => item.UnitPrice)
                .HasColumnType("decimal(18,2)");

            entity.Property(item => item.TotalPrice)
                .HasColumnType("decimal(18,2)");

            entity.Property(item => item.Quantity)
                .IsRequired();

            entity.HasOne(item => item.Order)
                .WithMany(order => order.Items)
                .HasForeignKey(item => item.OrderId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(item => item.Product)
                .WithMany()
                .HasForeignKey(item => item.ProductId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // ============================================================
        // STOCK MOVEMENT
        // ============================================================

        modelBuilder.Entity<StockMovement>(entity =>
        {
            entity.ToTable("StockMovements");

            entity.HasKey(movement => movement.Id);

            entity.Property(movement => movement.Quantity)
                .IsRequired();

            entity.Property(movement => movement.MovementType)
                .IsRequired()
                .HasMaxLength(50);

            entity.Property(movement => movement.ReferenceNumber)
                .HasMaxLength(100);

            entity.Property(movement => movement.CreatedAt)
                .IsRequired();

            entity.HasOne(movement => movement.Product)
                .WithMany()
                .HasForeignKey(movement => movement.ProductId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // ============================================================
        // FAVORITE
        // ============================================================

        modelBuilder.Entity<Favorite>(entity =>
        {
            entity.ToTable("Favorites");

            entity.HasKey(favorite => favorite.Id);

            entity.Property(favorite => favorite.UserId)
                .IsRequired();

            entity.Property(favorite => favorite.ProductId)
                .IsRequired();

            entity.Property(favorite => favorite.CreatedAt)
                .IsRequired();

            entity.HasIndex(favorite => new
            {
                favorite.UserId,
                favorite.ProductId
            })
            .IsUnique();

            // User -> Favorite
            entity.HasOne<User>()
                .WithMany()
                .HasForeignKey(favorite => favorite.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // Product -> Favorite
            entity.HasOne<Product>()
                .WithMany()
                .HasForeignKey(favorite => favorite.ProductId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ============================================================
        // CART ITEM
        // ============================================================

        modelBuilder.Entity<CartItem>(entity =>
        {
            entity.ToTable("CartItems");

            entity.HasKey(cartItem => cartItem.Id);

            entity.Property(cartItem => cartItem.UserId)
                .IsRequired();

            entity.Property(cartItem => cartItem.ProductId)
                .IsRequired();

            entity.Property(cartItem => cartItem.Quantity)
                .IsRequired();

            entity.Property(cartItem => cartItem.CreatedAt)
                .IsRequired();

            // Aynı kullanıcı aynı ürünü sepete
            // yalnızca bir kayıt olarak ekleyebilir.
            entity.HasIndex(cartItem => new
            {
                cartItem.UserId,
                cartItem.ProductId
            })
            .IsUnique();

            // User -> CartItem
            entity.HasOne(cartItem => cartItem.User)
                .WithMany()
                .HasForeignKey(cartItem => cartItem.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // Product -> CartItem
            entity.HasOne(cartItem => cartItem.Product)
                .WithMany()
                .HasForeignKey(cartItem => cartItem.ProductId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}