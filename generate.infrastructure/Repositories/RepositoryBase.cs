using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.Threading.Tasks;
using generate.core.Models.RDS;
using Microsoft.Extensions.Options;
using generate.core.Config;
using System.Diagnostics.CodeAnalysis;

namespace generate.infrastructure.Repositories
{

    public abstract class RepositoryBase
    {
        public DbContext _context;
        
        public RepositoryBase(DbContext context)
        {
            _context = context;

        }


        // Helpers

        public virtual string GetPrimaryKey<T>(T entity)
            where T : class
        {
            return _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).Single();
        }
        public virtual string GetConnectionString()
        {
            return _context.Database.GetDbConnection().ConnectionString;
        }


        // Create

        public virtual T Create<T>(T entity)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            _set.Add(entity);
            return entity;
        }
        public virtual IEnumerable<T> CreateRange<T>(IEnumerable<T> entities)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            _set.AddRange(entities);
            return entities;
        }
        public virtual IEnumerable<T> CreateRangeSave<T>(IEnumerable<T> entities)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            bool originalValue = _context.ChangeTracker.AutoDetectChangesEnabled;
            _context.ChangeTracker.AutoDetectChangesEnabled = false;
            _set.AddRange(entities);
            _context.SaveChanges();
            _context.ChangeTracker.AutoDetectChangesEnabled = originalValue;
            return entities;
        }

        public virtual void CreateRangeSaveDetach<T>(IEnumerable<T> entities)
           where T : class
        {

        }

        // Read

        public virtual IEnumerable<T> GetAllReadOnly<T>(int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            if (take == 0)
            {
                return GetAllQuery<T>(eagerLoad)
                    .AsNoTracking()
                    .ToList();
            }
            else
            {
                // Default sort by primary key
                var keyName = _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).FirstOrDefault();

                return GetAllQuery<T>(eagerLoad)
                    .AsNoTracking()
                    .OrderBy(e => EF.Property<int>(e, keyName))
                    .Skip(skip)
                    .Take(take)
                    .ToList();
            }
        }


        public virtual IEnumerable<T> GetAll<T>(int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            if (take == 0)
            {
                return GetAllQuery<T>(eagerLoad)
                    .AsNoTracking()
                    .ToList();
            }
            else
            {
                // Default sort by primary key
                var keyName = _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).FirstOrDefault();

                return GetAllQuery<T>(eagerLoad)
                    .OrderBy(e => EF.Property<int>(e, keyName))
                    .Skip(skip)
                    .Take(take)
                    .ToList();
            }
        }

        public virtual IEnumerable<T> GetDistinct<T>(Expression<Func<T, bool>> criteria, int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad)
             where T : class
        {
            if (take == 0)
            {
                return GetAllQuery<T>(eagerLoad)
                    .Where(criteria)
                    .Distinct()
                    .ToList();
            }
            else
            {
                // Default sort by primary key
                var keyName = _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).FirstOrDefault();

                return GetAllQuery<T>(eagerLoad)
                    .Where(criteria)
                    .OrderBy(e => EF.Property<int>(e, keyName))
                    .Skip(skip)
                    .Take(take)
                    .Distinct()
                    .ToList();
            }
        }

        public virtual IEnumerable<T> FindReadOnly<T>(Expression<Func<T, bool>> criteria, int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            if (take == 0)
            {
                return GetAllQuery<T>(eagerLoad)
                    .AsNoTracking()
                    .Where(criteria)
                    .ToList();
            }
            else
            {
                // Default sort by primary key
                var keyName = _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).FirstOrDefault();

                return GetAllQuery<T>(eagerLoad)
                    .AsNoTracking()
                    .Where(criteria)
                    .OrderBy(e => EF.Property<int>(e, keyName))
                    .Skip(skip)
                    .Take(take)
                    .ToList();
            }
        }

        public virtual IEnumerable<T> Find<T>(Expression<Func<T, bool>> criteria, int skip = 0, int take = 50, params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            if (take == 0)
            {
                return GetAllQuery<T>(eagerLoad)
                    .Where(criteria)
                    .ToList();
            }
            else
            {
                // Default sort by primary key
                var keyName = _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).FirstOrDefault();

                return GetAllQuery<T>(eagerLoad)
                    .Where(criteria)
                    .OrderBy(e => EF.Property<int>(e, keyName))
                    .Skip(skip)
                    .Take(take)
                    .ToList();
            }
        }

        public virtual int Count<T>(Expression<Func<T, bool>> criteria)
            where T : class
        {
            return GetAllQuery<T>()
                    .AsNoTracking()
                    .Where(criteria)
                    .Count();
        }
        
        protected virtual IQueryable<T> GetAllQuery<T>(params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();

            if (eagerLoad != null && eagerLoad.Length > 0)
            {
                return eagerLoad.Aggregate(_set.AsQueryable(), (c, i) => c.Include(i));
            }

            return _set;
        }

        public virtual T GetById<T>(int id)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            var keyName = _context.Model.FindEntityType(typeof(T)).FindPrimaryKey().Properties.Select(x => x.Name).FirstOrDefault();
            return _set.Where(e => EF.Property<int>(e, keyName) == id).FirstOrDefault();
        }

        
        public virtual bool Any<T>(params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            return GetAllQuery<T>(eagerLoad).Any();
        }

        public virtual bool Any<T>(Expression<Func<T, bool>> criteria, params Expression<Func<T, object>>[] eagerLoad)
            where T : class
        {
            return GetAllQuery<T>(eagerLoad).Any(criteria);
        }


        // Update

        public virtual void Update<T>(T entity)
            where T : class
        {
            _context.Entry<T>(entity).State = EntityState.Modified;
        }

        public virtual void UpdateRange<T>(IEnumerable<T> entities)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            _set.UpdateRange(entities);
        }

        public virtual void UpdateRangeSave<T>(IEnumerable<T> entities)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            bool originalValue = _context.ChangeTracker.AutoDetectChangesEnabled;
            _context.ChangeTracker.AutoDetectChangesEnabled = false;
            _set.UpdateRange(entities);
            _context.SaveChanges();
            _context.ChangeTracker.AutoDetectChangesEnabled = originalValue;
        }

        // Delete

        public virtual void Delete<T>(int id)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();
            var entity = GetById<T>(id);
            if (entity != null)
                _set.Remove(entity);
        }

        public virtual void DeleteRange<T>(IEnumerable<T> entities)
            where T : class
        {
            DbSet<T> _set = _context.Set<T>();

            int? oldTimeout = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(11000);

            _set.RemoveRange(entities);

            _context.Database.SetCommandTimeout(oldTimeout);
        }

       // Save


        public virtual int Save()
        {
            return _context.SaveChanges();
        }

        public virtual async void SaveAsync()
        {
            await _context.SaveChangesAsync();
        }

        // Execute

        public virtual void ExecuteSql(string sql, params object[] parameters)
        {
            int? oldTimeout = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(8000);
            _context.Database.ExecuteSqlRaw(sql, parameters);
            _context.Database.SetCommandTimeout(oldTimeout);
        }

    }

}
