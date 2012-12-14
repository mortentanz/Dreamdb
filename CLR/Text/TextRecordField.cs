#region Source file version
// $Archive: /CLR.root/CLR/Text/TextRecordField.cs $
// $Date: 12/18/06 15:48 $
// $Revision: 1 $ by 
// $Author: mls $
// 
// $Workfile: TextRecordField.cs $
// $Modtime: 9/11/06 14:25 $
#endregion
        
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

namespace Dreamdb.ETL.Text
{
  /// <summary>
  /// A TextRecordField holds meta data for an individual field of a text record. A TextRecordField defines type
  /// information regarding nullability and optionally default value definitionpertaining to the fields of
  /// a TextRecord.
  /// </summary>
  public class TextRecordField
  {
    private string m_name;
    private bool m_allowdbnull = true;
    private bool m_isheaderfield = true;
    private string m_default = null;

    /// <summary>
    /// Construct a text record field.
    /// </summary>
    /// <param name="name">The name of the field (required).</param>
    /// <exception cref="ArgumentException">Thrown if name is null or empty.</exception>
    public TextRecordField(string name)
    {
      if (string.IsNullOrEmpty(name))
      {
        throw new ArgumentException("A name is required but a null or empty string was passed.");
      }
      m_name = name;
    }

    /// <summary>
    /// Construct a text record field.
    /// </summary>
    /// <param name="name">The name of the field (required).</param>
    /// <param name="isheaderfield">Specify whether the field is a header field.</param>
    /// <exception cref="ArgumentException">Thrown if name is null or empty.</exception>
    public TextRecordField(string name, bool isheaderfield)
      : this(name)
    {
      m_isheaderfield = isheaderfield;
    }

    /// <summary>
    /// States whether the field is a header field.
    /// </summary>
    public bool IsHeaderField
    {
      get { return m_isheaderfield; }
    }

    /// <summary>
    /// The name of the text record field as passed in the constructor.
    /// </summary>
    public string Name
    {
      get { return m_name; }
      internal set { m_name = value; }
    }

    /// <summary>
    /// States whether the absence of a value for this field should be interpreted as DbNull.
    /// </summary>
    public bool AllowDBNull
    {
      get { return m_allowdbnull; }
      set { m_allowdbnull = value; }
    }

    /// <summary>
    /// Specify a default value for the text record field (may be null).
    /// </summary>
    public string Default
    {
      get { return m_default; }
      set { m_default = value; }
    }
  }
}