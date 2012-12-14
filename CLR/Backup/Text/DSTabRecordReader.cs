#region Sourcesafe version
// $Archive: /CLR.root/CLR/Text/DSTabRecordReader.cs $
// $Author: mls $
// $Revision: 1 $
// $Date: 12/18/06 15:48 $
// $Workfile: DSTabRecordReader.cs $
// $Modtime: 9/28/06 14:30 $
#endregion

#region Using directives
using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text;
#endregion

namespace Dreamdb.ETL.Text
{
  public sealed class DSTabRecordReader : TextRecordReader
  {

    private DataTable m_schematable;
    private DataTable m_origins;
    
    public DSTabRecordReader(TextRecordParser parser) : base(parser) 
    {
      SetupSchema();
      LoadOriginTable();
    }

    /// <summary>
    /// Returns a System.Data.DataTable that describes the field metadata of the DSTabRecordReader.
    /// </summary>
    /// <returns>A System.Data.DataTable that describes the field metadata.</returns>
    public override System.Data.DataTable GetSchemaTable()
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to access fields in a closed DSTabRecordReader.");
      }
      return m_schematable;
    }

    /// <summary>
    /// Gets the name of the specified field.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The name of the specified field.</returns>
    public override string GetName(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to access a closed DSTabRecordReader.");
      }
      if (i != 1)
      {
        return base.GetName(i);
      }
      else
      {
        return "originid";
      }
    }

    /// <summary>
    /// Gets the field ordinal given a field name.
    /// </summary>
    /// <param name="name">The name of the field.</param>
    /// <returns>The zero-based field index.</returns>
    /// <summary>
    public override int GetOrdinal(string name)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to access a closed DSTabRecordReader.");
      }
      if (name == "originid")
      {
        return 1;
      }
      else
      {
        return base.GetOrdinal(name);
      }
    }

    /// <summary>
    /// Releases resources held by the DSTabRecordReader.
    /// </summary>
    public override void Dispose()
    {
      m_origins.Dispose();
      m_schematable.Dispose();
      base.Dispose();
    }

    /// <summary>
    /// Gets the value of the the specified field as a System.String.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The field value.</returns>
    public override string GetString(int i)
    {
      if (m_schematable.Columns[i].DataType != typeof(string))
      {
        throw new InvalidCastException("The specified field does not contain a string value");
      }
      return base.GetString(i);
    }

    /// <summary>
    /// Gets the name of the System.Type of the value held in the specified field.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The name of the type of value held in the field.</returns>
    public override string GetDataTypeName(int i)
    {
      return m_schematable.Columns[i].DataType.Name;
    }

    /// <summary>
    /// Gets the System.Type of value held in the specified field.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The type of value held in the field.</returns>
    public override Type GetFieldType(int i)
    {
      return m_schematable.Columns[i].DataType;
    }

    /// <summary>
    /// Gets the value of the specified field as a System.DateTime.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The field value.</returns>
    public override DateTime GetDateTime(int i)
    {
      if (m_schematable.Columns[i].DataType != typeof(DateTime))
      {
        throw new InvalidCastException("The specified field does not contain a DateTime value.");
      }
      else
      {
        int y = int.Parse((string)m_parser.Current[i]);
        y = (y > 40) ? 1900 + y : 2000 + y;
        return new DateTime(y, 1, 1);
      }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Int32.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The field value.</returns>
    public override int GetInt32(int i)
    {
      if (m_schematable.Columns[i].DataType == typeof(Int16))
      {
        return (Int32)GetInt16(i);
      }
      else if (m_schematable.Columns[i].DataType == typeof(Int32))
      {
        return Convert.ToInt32(m_parser.Current[i], m_parser.Format.CultureInfo);
      }
      else
      {
        throw new InvalidCastException("The specified field does not contain a value that may be cast to Int32.");
      }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Int16.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The field value.</returns>
    public override short GetInt16(int i)
    {
      switch (m_parser.Current.GetName(i))
      {
        case "origincode":
          return FindOriginID();

        default:
          try
          {
            return Convert.ToInt16(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
          }
          catch
          {
            throw new InvalidCastException("The specified field does not contain a value that can be cast to Int16.");
          }
      }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Byte.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The field value.</returns>
    public override byte GetByte(int i)
    {
      if (m_schematable.Columns[i].DataType == typeof(Byte))
      {
        return Convert.ToByte(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
      }
      else
      {
        throw new InvalidCastException("The specified field does not contain a value that can be cast to Byte.");
      }
    }

    #region Private methods

    /// <summary>
    /// Initializes the DataTable m_schema.
    /// </summary>
    private void SetupSchema()
    {
      m_schematable = new DataTable();

      DataColumn[] cs = new DataColumn[7];

      cs[0] = new DataColumn("contentcode");
      cs[0].DataType = typeof(System.String);
      cs[0].MaxLength = 4;
      cs[0].AllowDBNull = false;

      cs[1] = new DataColumn("originid");
      cs[1].DataType = typeof(System.Int16);
      cs[1].AllowDBNull = true;

      cs[2] = new DataColumn("year");
      cs[2].DataType = typeof(System.Int16);
      cs[2].AllowDBNull = false;

      cs[3] = new DataColumn("age");
      cs[3].DataType = typeof(System.Byte);
      cs[3].AllowDBNull = false;

      cs[4] = new DataColumn("male");
      cs[4].DataType = typeof(System.Int32);
      cs[4].AllowDBNull = true;

      cs[5] = new DataColumn("female");
      cs[5].DataType = typeof(System.Int32);
      cs[5].AllowDBNull = true;

      cs[6] = new DataColumn("total");
      cs[6].DataType = typeof(System.Int32);
      cs[6].AllowDBNull = true;

      foreach (DataColumn c in cs)
      {
        m_schematable.Columns.Add(c);
      }
    }

    /// <summary>
    /// Loads the current database values for origin group identifiers.
    /// </summary>
    private void LoadOriginTable()
    {
      m_origins = new DataTable();
      using (SqlConnection dbconn = new SqlConnection("context connection = true"))
      {
        
        using(SqlCommand dbcmd = new SqlCommand())
        {
          dbcmd.CommandText = "ETL.GetDSOriginClassification";
          dbcmd.CommandType = CommandType.StoredProcedure;
          SqlParameter dbparam = dbcmd.Parameters.Add("@includeresidual", SqlDbType.Bit);
          dbparam.Direction = ParameterDirection.Input;
          dbparam.Value = true;

          dbcmd.Connection = dbconn;
          using (SqlDataAdapter dbda = new SqlDataAdapter(dbcmd))
          {
            dbda.Fill(m_origins);
          }
        }
      }
      m_origins.PrimaryKey = new DataColumn[] { m_origins.Columns["DSID"] };
    }

    /// <summary>
    /// Returns an integer (Int16) holding the identifier for the current origin group.
    /// </summary>
    /// <returns>The identifier or -1 if the current origincode is not a valid DSID.</returns>
    private short FindOriginID()
    {
      object code = m_parser.Current["origincode"];
      DataRow r = m_origins.Rows.Find(code);
      if (r != null)
      {
        return (short)r["OriginID"];
      }
      else
      {
        return -1;
      }
    }
    #endregion
  }
}