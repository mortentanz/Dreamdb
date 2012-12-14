#region Source file version
// $Archive: /CLR.root/CLR/Text/TextRecord.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: TextRecord.cs $
// $Modtime: 9/11/06 14:25 $
#endregion
        
using System;
using System.Data;
using System.Collections.Generic;
using System.Text;

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// Contains the string values of a text record of a specific format.
  /// </summary>
  public class TextRecord
  {
    private TextRecordFormat m_format;
    private string[] m_values;

    /// <summary>
    /// Construct a new TextRecord based on a format.
    /// </summary>
    /// <param name="format">A <c>TextRecordFormat</c> that the new record is based on.</param>
    public TextRecord(TextRecordFormat format)
    {
      m_format = format;
      m_values = new string[m_format.Fields.Count];
      int i = 0;
      foreach (TextRecordField f in m_format.Fields)
      {
        if (f.Default != null)
        {
          m_values[i] = f.Default;
        }
        else if(!f.AllowDBNull)
        {
          m_values[i] = string.Empty;
        }
        i++;
      }
    }

    /// <summary>
    /// The number of fields in the record.
    /// </summary>
    public int FieldCount
    {
      get { return m_format.Fields.Count; }
    }

    /// <summary>
    /// Call to get the name of a field from its ordinal index.
    /// </summary>
    /// <param name="i">The zero-based ordinal index of the field.</param>
    /// <returns>The name of the field.</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown if the index is outside the range of 0 through TextRecord.FieldCount.</exception>
    public string GetName(int i)
    {
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecord.FieldCount - 1.");
      }
      return m_format.Fields[i].Name;
    }

    /// <summary>
    /// Call to get the zero-based ordinal index of a field.
    /// </summary>
    /// <param name="name">The name of the field for which to obtain the ordinal index.</param>
    /// <returns>The zero-based ordinal position of the field.</returns>
    /// <exception cref="ArgumentException">The name specified is not a valid field.</exception>
    public int GetOrdinal(string name)
    {
      int ordinal = m_format.Fields.IndexOf(name);
      if (ordinal == -1)
      {
        throw new ArgumentException("The name specified is not a valid field.");
      }
      return ordinal;
    }

    /// <summary>
    /// Call to obtain all field values.
    /// </summary>
    /// <param name="values">An array of strings containing the field values.</param>
    /// <returns>The length of the returned array (the field count).</returns>
    public int GetValues(string[] values)
    {
      values = m_values;
      return m_values.Length;
    }

    /// <summary>
    /// Call to obtain the value of a field by its ordinal index.
    /// </summary>
    /// <param name="i">The zero-based ordinal position of the field.</param>
    /// <returns>The value of the field (may be empty or null).</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown if the index is outside the range of 0 through TextRecord.FieldCount.</exception>
    public string GetValue(int i)
    {
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecord.FieldCount - 1.");
      }
      return m_values[i];
    }

    /// <summary>
    /// Call to examine if a field value is equivalent to DBNull.
    /// </summary>
    /// <param name="i">The zero-based ordinal position of the field.</param>
    /// <returns>True if the format allows for DBNull and the field value is null, false otherwise.</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown if the index is outside the range of 0 through TextRecord.FieldCount.</exception>
    public bool IsDBNull(int i)
    {
      if (OutOfRange(i))
      {
        throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecord.FieldCount - 1.");
      }
      TextRecordField f = m_format.Fields[i];
      return (f.AllowDBNull && m_values[i] == null);
    }

    /// <summary>
    /// Gets or sets the value of a field specified by its ordinal index.
    /// </summary>
    /// <param name="i">The zero-based ordinal position of the field.</param>
    /// <returns>The value of the field, the value can be either a string (including an empty string) or DBNull.</returns>
    /// <exception cref="ArgumentOutOfRangeException">Thrown if the index is outside the range of 0 through TextRecord.FieldCount - 1.</exception>
    /// <exception cref="ArgumentNullException">Thrown of the specified value is null or DBNull and the format prohibits DBNull values.</exception>
    public object this[int i]
    {
      get
      {
        if (OutOfRange(i))
        {
          throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecord.FieldCount - 1.");
        }
        if (m_format.Fields[i].AllowDBNull && m_values[i] == null)
        {
          return DBNull.Value;
        }
        else
        {
          return m_values[i];
        }
      }

      set
      {
        if (OutOfRange(i))
        {
          throw new ArgumentOutOfRangeException("The index passed was outside the range of 0 through TextRecord.FieldCount - 1.");
        }

        if (value == null || value == DBNull.Value)
        {
          if (!m_format.Fields[i].AllowDBNull)
          {
            throw new ArgumentNullException("The field does not allow DBNull values but null or DBNull.Value was passed.");
          }
          else
          {
            m_values[i] = null;
          }
        }
        else
        {
          if (value.GetType() == typeof(string))
          {
            m_values[i] = (string)value;
          }
          else
          {
            m_values[i] = Convert.ToString(value);
          }
        }
      }
    }

    /// <summary>
    /// Gets or sets the value of a field specified by its name.
    /// </summary>
    /// <param name="name">The name of the field.</param>
    /// <returns>The value of the field, the value will be either a string or DBNull.</returns>
    /// <exception cref="ArgumentException">The specified name is not a valid field.</exception>
    /// <exception cref="ArgumentNullException">The specified value is null or DBNull and the format prohibits DBNull values.</exception>
    public object this[string name]
    {
      get
      {
        int i = GetOrdinal(name);
        return this[i];
      }
      set
      {
        int i = GetOrdinal(name); 
        this[i] = value;
      }
    }

    private bool OutOfRange(int i)
    {
      return (0 > i || i > m_format.Fields.Count - 1);
    }
  }
}