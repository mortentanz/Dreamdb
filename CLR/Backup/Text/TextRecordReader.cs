#region Sourcesafe version
// $Archive: /CLR.root/CLR/Text/TextRecordReader.cs $
// $Author: mls $
// $Revision: 1 $
// $Date: 12/18/06 15:48 $
// $Workfile: TextRecordReader.cs $
// $Modtime: 9/11/06 14:25 $
#endregion

#region Using directives
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
#endregion

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// Provides a default implementation of the IDataReader interface for reading the TextRecord objects returned by a TextRecordParser.
  /// </summary>
  public class TextRecordReader : IDataReader
  {

    protected TextRecordParser m_parser;
    protected bool m_isclosed = false;
    
    /// <summary>
    /// Construct a new TextRecordReader associated with a parser.
    /// </summary>
    /// <param name="parser">A TextRecordParser providing the TextRecord objects to read (required).</param>
    /// <exception cref="ArgumentNullException">The specified TextRecordParser is null.</exception>
    public TextRecordReader(TextRecordParser parser)
    {
      if (parser == null)
      {
        throw new ArgumentNullException("The specified TextRecordParser is null.");
      }
      m_parser = parser;
    }

    #region IDataReader Members

    /// <summary>
    /// Closes the current TextRecordReader.
    /// </summary>
    public void Close()
    {
      if (m_parser != null)
      {
        m_parser.Reset();
      }
      m_isclosed = true;
    }

    /// <summary>
    /// Gets a value indicating the depth of nesting for the current row. (always 0 for TextRecordReader since hierarchial result sets are not supported).
    /// </summary>
    public int Depth
    {
      get { return 0; }
    }

    /// <summary>
    /// Returns a System.Data.DataTable that describes the field metadata of the TextRecordReader.
    /// </summary>
    /// <returns>A System.Data.DataTable that describes the field metadata.</returns>
    public virtual DataTable GetSchemaTable()
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to access fields in a closed TextDataReader.");
      }
      DataTable sdt = new DataTable();
      foreach (TextRecordField f in m_parser.Format.Fields)
      {
        DataColumn c = new DataColumn(f.Name, typeof(string));
        c.AllowDBNull = f.AllowDBNull;
        if (f.Default != null)
        {
          c.DefaultValue = f.Default;
        }
        sdt.Columns.Add(c);
      }
      return sdt;
    }

    /// <summary>
    /// Gets a value indicating if the TextRecordReader is closed.
    /// </summary>
    public bool IsClosed
    {
      get { return m_isclosed || m_parser == null; }
    }

    /// <summary>
    /// Advances the TextRecordReader to the next result set if any.
    /// </summary>
    /// <returns>Always returns false for the default TextRecordReader since multiple result sets are not supported.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to navigate within a closed TextRecordReader.</exception>
    public virtual bool NextResult()
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to navigate within a closed TextRecordReader.");
      }
      return false;
    }

    /// <summary>
    /// Advances the TextRecordReader to the next record.
    /// </summary>
    /// <returns>true if there was another record to read, false otherwise.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to navigate within a closed TextRecordReader.</exception>
    public virtual bool Read()
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to navigate within a closed TextRecordReader.");
      }
      return m_parser.MoveNext();
    }

    /// <summary>
    /// The number of records affected.
    /// </summary>
    /// <remarks>Always returns -1 for the TextRecordReader since update, insert and deletes are not supported.</remarks>
    public int RecordsAffected
    {
      get { return -1; }
    }

    #endregion

    #region IDisposable Members

    /// <summary>
    /// Releases all unmanaged resources held by the current TextRecordReader.
    /// </summary>
    public virtual void Dispose()
    {
      if (m_parser != null)
      {
        m_parser.Dispose();
      }
    }

    #endregion

    #region IDataRecord Members

    /// <summary>
    /// Returns the number of fields in the current TextRecord.
    /// </summary>
    public int FieldCount
    {
      get { return m_parser.Format.Fields.Count; }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Boolean.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a boolean.</exception>
    /// <returns>The value of the specified field.</returns>
    public virtual bool GetBoolean(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to access a value in a closed TextRecordReader.");
      }
      return Convert.ToBoolean(m_parser.Current.GetValue(i));
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Byte.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Byte.</exception>
    /// <returns>The value of the specified field.</returns>
    public virtual byte GetByte(int i)
    {
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The passed index was outside the range of 0 through TextRecordReader.FieldCount - 1.");
      }
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to access a value in a closed TextRecordReader.");
      }
      return Convert.ToByte(m_parser.Current.GetValue(i));

    }

    /// <summary>
    /// Reads a stream of bytes from the specified column, starting at location indicated by dataIndex, 
    /// into the buffer, starting at the location indicated by bufferIndex.
    /// </summary>
    /// <param name="i">The zero-based field ordinal.</param>
    /// <param name="fieldOffset">The index within the field from which to begin the read operation.</param>
    /// <param name="buffer">The buffer into which to copy the data.</param>
    /// <param name="bufferoffset">The index with the buffer to which the data will be copied.</param>
    /// <param name="length">The maximum number of characters to read.</param>
    /// <returns>The actual number of bytes read.</returns>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a byte array.</exception>
    /// <remarks>The TextRecordReader will always throw InvalidCastOperation in the default implementation.</remarks>
    public virtual long GetBytes(int i, long fieldOffset, byte[] buffer, int bufferoffset, int length)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.");
      }
      throw new InvalidCastException("The TextRecordReader does not support storage of byte arrays.");
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Char.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Char.</exception>
    /// <returns>The value of the specified field.</returns>
    public char GetChar(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToChar(m_parser.Current.GetValue(i));
    }

    /// <summary>
    /// Returns the value of the specified field as a character array.
    /// </summary>
    /// <param name="i">The zero-based field ordinal.</param>
    /// <param name="fieldoffset">The index within the field from which to start the read operation.</param>
    /// <param name="buffer">The buffer into which to read the stream of characters.</param>
    /// <param name="bufferoffset">The index within the buffer at which to start placing the data.</param>
    /// <param name="length">The maximum length to copy into the buffer.</param>
    /// <returns>The actual number of characters read.</returns>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <remarks>This method always return the underlying character data in the text record.</remarks>
    public long GetChars(int i, long fieldoffset, char[] buffer, int bufferoffset, int length)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      char[] cs = m_parser.Current.GetValue(i).ToCharArray();

      if (cs.LongLength - fieldoffset > length)
      {
        long c = fieldoffset;
        for (long b = bufferoffset; b < length; b++)
        {
          buffer[b] = cs[c];
          c++;
        }
        return length;
      }
      else
      {
        long b = bufferoffset;
        for (long c = fieldoffset; c < cs.LongLength; c++)
        {
          buffer[b] = cs[c];
          b++;
        }
        return b;
      }
    }

    /// <summary>
    /// Gets an System.Data.IDataReader to be used when the field points to more remote structured data.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>An System.Data.IDataReader to be used when the field points to more remote structured data.</returns>
    /// <exception cref="NotSupportedOperation">Always thrown by TextRecordReader objects, since nested result sets are not supported.</exception>
    IDataReader IDataRecord.GetData(int i)
    {
      throw new NotSupportedException("The TextRecordReader does not support nested result sets.");
    }

    /// <summary>
    /// Gets a string representing the data type of the specified field.
    /// </summary>
    /// <param name="i">The zero-based ordinal of the field.</param>
    /// <returns>a string representing the fields data type.</returns>
    public virtual string GetDataTypeName(int i)
    {
      if (m_parser.Format.Fields[i].AllowDBNull)
      {
        return typeof(object).Name;
      }
      else
      {
        return typeof(string).Name;
      }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.DateTime.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Char.</exception>
    public virtual DateTime GetDateTime(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToDateTime(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Decimal.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Decimal.</exception>
    public virtual decimal GetDecimal(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToDecimal(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Double.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Double.</exception>
    public virtual double GetDouble(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToDouble(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the System.Data.Type that is the data type of the object.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The System.Data.Type that is the data type of the object.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    public virtual Type GetFieldType(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      if (m_parser.Format.Fields[i].AllowDBNull)
      {
        return typeof(object);
      }
      else
      {
        return typeof(string);
      }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Float.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Float.</exception>
    public virtual float GetFloat(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToSingle(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Guid.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Guid.</exception>
    public virtual Guid GetGuid(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecord.FieldCount - 1.");
      }
      try
      {
        return new Guid(m_parser.Current.GetValue(i));
      }
      catch (ArgumentOutOfRangeException)
      {
        throw;
      }
      catch
      {
        throw new InvalidCastException("The field could not be cast to a System.Guid.");
      }
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Int16.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Int16.</exception>
    public virtual short GetInt16(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToInt16(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Int32.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Int32.</exception>
    public virtual int GetInt32(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToInt32(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the value of the specified field as a System.Int64.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <exception cref="InvalidCastException">The specified field could not be cast to a System.Int64.</exception>
    public virtual long GetInt64(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return Convert.ToInt64(m_parser.Current.GetValue(i), m_parser.Format.CultureInfo);
    }

    /// <summary>
    /// Gets the name of the specified field.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The name of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    public virtual string GetName(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return m_parser.Format.Fields[i].Name;
    }

    /// <summary>
    /// Gets the field ordinal given a field name.
    /// </summary>
    /// <param name="name">The name of the field.</param>
    /// <returns>The zero-based field index.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentException">The name specified is not a valid field.</exception>
    public virtual int GetOrdinal(string name)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      int i = m_parser.Format.Fields.IndexOf(name);
      if (i == -1)
      {
        throw new ArgumentException("The name specified is not a valid field.");
      }
      return i;
    }

    /// <summary>
    /// Gets the value of the specified field as a System.String.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <remarks>This method always return the original string in the text record.</remarks>
    public virtual string GetString(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return m_parser.Current.GetValue(i);      
    }

    /// <summary>
    /// Gets the value of the specified field.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the specified field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <remarks>This version of the method returns the string content of the field or, if equivalent, DBNull.Value.</remarks>
    public virtual object GetValue(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      return m_parser.Current[i];
    }

    /// <summary>
    /// Gets all field values in the current text record.
    /// </summary>
    /// <param name="values">An array of System.Object to copy the values into.</param>
    /// <returns>The number of value object instances in the array returned.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    public virtual int GetValues(object[] values)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      object[] vals = new object[FieldCount];
      for (int i = 0; i < FieldCount; i++)
      {
        vals[i] = m_parser.Current[i];
      }
      values = vals;
      return FieldCount;
    }

    /// <summary>
    /// Gets a value that indicates whether the specified field contains non-existent or missing values.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>true if the specified column value is equivalent to System.DBNull, false otherwise.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    public bool IsDBNull(int i)
    {
      if (IsClosed)
      {
        throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
      }
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.");
      }
      return (m_parser.Format.Fields[i].AllowDBNull && m_parser.Current[i] == DBNull.Value);
    }

    /// <summary>
    /// Gets the value of the specified field.
    /// </summary>
    /// <param name="name">The name of the field.</param>
    /// <returns>The value of the field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentException">The name specified is  not a valid field.</exception>
    /// <remarks>This version of the method returns the string content of the field or, if equivalent, DBNull.Value.</remarks>
    public virtual object this[string name]
    {
      get
      {
        if (IsClosed)
        {
          throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
        }
        return m_parser.Current[name];
      }
    }

    /// <summary>
    /// Gets the value of the specified field.
    /// </summary>
    /// <param name="i">The zero-based index of the field.</param>
    /// <returns>The value of the field.</returns>
    /// <exception cref="InvalidOperationException">An attempt was made to read from a closed TextDataReader.</exception>
    /// <exception cref="ArgumentOutOfRangeException">The index passed was outside the range of 0 through TextRecordReader.FieldCount - 1.</exception>
    /// <remarks>This version of the method returns the string content of the field or, if equivalent, DBNull.Value.</remarks>
    public virtual object this[int i]
    {
      get 
      {
        if (IsClosed)
        {
          throw new InvalidOperationException("An attempt was made to read from a closed TextDataReader.");
        }
        return m_parser.Current[i];
      }
    }

    #endregion

    private bool OutOfRange(int i)
    {
      return (0 > i || i > m_parser.Format.Fields.Count - 1);
    }

  }
}
